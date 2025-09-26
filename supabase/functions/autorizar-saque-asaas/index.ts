import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { corsHeaders } from '../_shared/cors.ts';

serve(async (req: Request) => {
  // Lida com a requisição pre-flight de CORS.
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    // 1. VERIFICAÇÃO DE SEGURANÇA
    // Pega o token secreto guardado no Supabase.
    const secretToken = Deno.env.get('ASAAS_WEBHOOK_SECRET_SEGURANCA');
    const receivedToken = req.headers.get('asaas-access-token');

    // Compara o token recebido com o esperado.
    if (!secretToken || receivedToken !== secretToken) {
      console.error('ERRO DE AUTENTICAÇÃO: Token do webhook de SEGURANÇA inválido.');
      return new Response('Acesso negado.', { status: 403 });
    }

    const payload = await req.json();
    console.log('Webhook de autorização de saque autenticado. Payload:', payload);

    // 2. APROVAÇÃO DO SAQUE
    // Responde ao Asaas que o saque está aprovado para prosseguir.
    const approvalResponse = {
      status: 'APPROVED'
    };

    return new Response(JSON.stringify(approvalResponse), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    });

  } catch (error) {
    console.error('Erro CRÍTICO ao processar webhook de autorização de saque:', error);
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 500,
    });
  }
});