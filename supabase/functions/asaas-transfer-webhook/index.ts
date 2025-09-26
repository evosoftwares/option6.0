import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

// Define a estrutura esperada do payload do webhook de transferência do Asaas.
interface AsaasTransferPayload {
  event: 'TRANSFER_DONE' | 'TRANSFER_FAILED' | 'TRANSFER_CANCELLED' | string;
  transfer: {
    id: string; // ID da transferência no Asaas
    value: number;
    // Adicionar outros campos da transferência se necessário
  };
}

serve(async (req: Request) => {
  // 1. VERIFICAÇÃO DE SEGURANÇA E MÉTODO
  if (req.method !== 'POST') {
    return new Response('Método não permitido', { status: 405 });
  }

  // Valida o token do webhook para garantir que a chamada é legítima.
  const asaasToken = Deno.env.get('ASAAS_WEBHOOK_TOKEN'); // Reutilizamos o mesmo token do outro webhook.
  const receivedToken = req.headers.get('asaas-access-token');

  if (!asaasToken || receivedToken !== asaasToken) {
    console.error('Tentativa de acesso não autorizado: Token de webhook de transferência inválido.');
    return new Response('Acesso não autorizado.', { status: 401 });
  }

  try {
    const payload: AsaasTransferPayload = await req.json();
    console.log(`Webhook de Transferência Asaas recebido: Evento ${payload.event}, Transfer ID ${payload.transfer.id}`);

    // 2. PROCESSAMENTO DO EVENTO
    // Focamos apenas em eventos que finalizam uma transferência (sucesso ou falha).
    if (payload.event !== 'TRANSFER_DONE' && payload.event !== 'TRANSFER_FAILED' && payload.event !== 'TRANSFER_CANCELLED') {
      console.log(`Evento de transferência '${payload.event}' ignorado.`);
      return new Response(`Evento '${payload.event}' ignorado.`, { status: 200 });
    }

    const asaasTransferId = payload.transfer.id;

    // 3. LÓGICA DE NEGÓCIO - INTERAÇÃO COM O SUPABASE
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // Busca o registro de saque pendente correspondente.
    const { data: withdrawal, error: withdrawalError } = await supabaseAdmin
      .from('withdrawals')
      .select(`
        id,
        amount,
        driver_wallets ( id )
      `)
      .eq('asaas_transfer_id', asaasTransferId)
      .eq('status', 'processing') // Assume que o status muda para 'processing' quando o saque é iniciado.
      .single();

    if (withdrawalError || !withdrawal) {
      console.warn(`Saque com asaas_transfer_id ${asaasTransferId} não encontrado, já processado ou erro:`, withdrawalError);
      return new Response('Registro de saque não encontrado ou já processado.', { status: 200 });
    }

    // 4. ATUALIZAÇÃO DO STATUS E SALDO
    if (payload.event === 'TRANSFER_DONE') {
      // Se o saque foi concluído com sucesso, debitamos o valor da carteira.
      const { error: rpcError } = await supabaseAdmin.rpc('debitar_saque_motorista', {
        p_wallet_id: withdrawal.driver_wallets.id,
        p_amount: withdrawal.amount,
      });

      if (rpcError) {
        throw new Error(`Erro ao executar RPC para debitar saque: ${rpcError.message}`);
      }

      // Atualiza o status do saque para 'completed'.
      await supabaseAdmin
        .from('withdrawals')
        .update({
          status: 'completed',
          completed_at: new Date().toISOString()
        })
        .eq('id', withdrawal.id);

      console.log(`Saque de ${withdrawal.amount} debitado com sucesso da carteira ${withdrawal.driver_wallets.id}.`);

    } else { // Se o evento for TRANSFER_FAILED ou TRANSFER_CANCELLED
      // Se o saque falhou, apenas atualizamos o status e não mexemos no saldo.
      // A lógica para devolver o saldo ao 'available_balance' pode ser adicionada aqui se necessário.
      await supabaseAdmin
        .from('withdrawals')
        .update({
          status: 'failed',
          failure_reason: `Evento Asaas: ${payload.event}`,
          processed_at: new Date().toISOString()
        })
        .eq('id', withdrawal.id);

      console.warn(`Saque ${withdrawal.id} falhou ou foi cancelado. Status atualizado.`);
    }

    return new Response('Webhook de transferência processado!', { status: 200 });

  } catch (error) {
    console.error('Erro CRÍTICO ao processar webhook de transferência:', error);
    return new Response('Erro interno do servidor.', { status: 500 });
  }
});