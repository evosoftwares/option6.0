import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

// Interface para definir a estrutura esperada do corpo da requisição (payload) do Asaas.
interface AsaasWebhookPayload {
  event: 'PAYMENT_CONFIRMED' | 'PAYMENT_RECEIVED' | string; // Tipos de evento esperados
  payment: {
    id: string; // ID do pagamento no Asaas
    // Adicionar outros campos do pagamento se necessário
  };
}

serve(async (req: Request) => {
  // 1. VERIFICAÇÃO DE SEGURANÇA E MÉTODO
  if (req.method !== 'POST') {
    return new Response('Método não permitido', { status: 405 });
  }

  // A verificação de token é crucial para garantir que a chamada venha do Asaas.
  const asaasToken = Deno.env.get('ASAAS_WEBHOOK_TOKEN');
  const receivedToken = req.headers.get('asaas-access-token');

  if (!asaasToken || receivedToken !== asaasToken) {
    console.error('Tentativa de acesso não autorizado: Token de webhook inválido.');
    return new Response('Acesso não autorizado.', { status: 401 });
  }

  try {
    const payload: AsaasWebhookPayload = await req.json();
    console.log(`Webhook do Asaas recebido e autorizado: Evento ${payload.event}, Payment ID ${payload.payment.id}`);

    // 2. PROCESSAMENTO DO EVENTO
    // Ignora eventos que não são de confirmação de pagamento.
    if (payload.event !== 'PAYMENT_CONFIRMED' && payload.event !== 'PAYMENT_RECEIVED') {
      console.log(`Evento '${payload.event}' ignorado.`);
      return new Response(`Evento '${payload.event}' ignorado.`, { status: 200 });
    }

    const asaasPaymentId = payload.payment.id;

    // 3. LÓGICA DE NEGÓCIO - INTERAÇÃO COM O SUPABASE
    // É crucial criar um cliente Supabase com a 'service_role' key para ter permissões de escrita no backend.
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // Busca a transação pendente correspondente ao pagamento recebido.
    const { data: transaction, error: transactionError } = await supabaseAdmin
      .from('passenger_wallet_transactions')
      .select(`
        id,
        amount,
        passenger_id,
        passenger_wallets ( id )
      `)
      .eq('asaas_payment_id', asaasPaymentId)
      .eq('status', 'pending')
      .single();

    if (transactionError || !transaction) {
      console.warn(`Transação com asaas_payment_id ${asaasPaymentId} não encontrada, já processada ou erro:`, transactionError);
      return new Response('Transação não encontrada ou já processada.', { status: 200 });
    }

    // 4. ATUALIZAÇÃO ATÔMICA - CHAMADA DA FUNÇÃO RPC
    // Esta é a forma mais segura de atualizar o saldo, evitando condições de corrida.
    const { error: rpcError } = await supabaseAdmin.rpc('creditar_saldo_passageiro', {
      p_wallet_id: transaction.passenger_wallets.id,
      p_amount: transaction.amount,
    });

    if (rpcError) {
      throw new Error(`Erro ao executar RPC para creditar saldo: ${rpcError.message}`);
    }

    // Após o sucesso da RPC, atualiza o status da transação original.
    const { error: updateError } = await supabaseAdmin
      .from('passenger_wallet_transactions')
      .update({
        status: 'completed',
        processed_at: new Date().toISOString()
      })
      .eq('id', transaction.id);

    if (updateError) {
      // Embora o saldo já tenha sido creditado, logamos o erro de atualização do status.
      console.error(`SALDO CREDITADO, mas falha ao atualizar status da transação ${transaction.id}:`, updateError);
    }

    console.log(`Saldo de ${transaction.amount} creditado com sucesso para a carteira ${transaction.passenger_wallets.id}.`);
    return new Response('Webhook processado com sucesso!', { status: 200 });

  } catch (error) {
    console.error('Erro CRÍTICO ao processar webhook do Asaas:', error);
    return new Response('Erro interno do servidor.', { status: 500 });
  }
});