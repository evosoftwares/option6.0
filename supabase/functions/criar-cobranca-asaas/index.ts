import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

serve(async (req: Request) => {
  // Configura o CORS para permitir chamadas do seu app
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      }
    })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    // Verifica se o usuário que está chamando a função está autenticado
    const { data: { user } } = await supabaseClient.auth.getUser()
    if (!user) {
      return new Response(JSON.stringify({ error: 'Usuário não autenticado' }), { status: 401, headers: { 'Content-Type': 'application/json' } })
    }

    // Pega os dados da cobrança enviados pelo app Flutter
    const body = await req.json()

    // Pega a chave secreta do Asaas que está guardada no Supabase
    const asaasApiKey = Deno.env.get('ASAAS_API_KEY')
    if (!asaasApiKey) {
      throw new Error('Chave da API do Asaas não configurada nas Secrets.')
    }

    // Faz a chamada para a API do Asaas a partir do servidor
    const asaasResponse = await fetch('https://api.asaas.com/v3/payments', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'access_token': asaasApiKey
      },
      body: JSON.stringify(body),
    })

    const responseData = await asaasResponse.json()

    if (!asaasResponse.ok) {
      // Se o Asaas retornou um erro, repassa o erro para o app
      return new Response(JSON.stringify(responseData), { status: asaasResponse.status, headers: { 'Content-Type': 'application/json' } })
    }

    // Se deu tudo certo, retorna a resposta do Asaas para o app
    return new Response(JSON.stringify(responseData), { status: 200, headers: { 'Content-Type': 'application/json' } })

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500, headers: { 'Content-Type': 'application/json' } })
  }
})