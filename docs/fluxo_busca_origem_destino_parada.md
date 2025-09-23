# Documentação: Tela de Busca (Origem, Destino e Paradas) e Integração no Fluxo do Passageiro

## Objetivo
Padronizar como a tela de busca de locais (SearchScreen) captura endereços, retorna um resultado para a tela anterior e armazena esses dados como `FFPlace` para origem, destino e paradas.

## Contexto Atual
- Rota da SearchScreen definida via GoRouter sem retorno de resultado para o chamador.
- Parâmetro de entrada `origemDestinoParada` diferencia o contexto da busca: "origem", "destino" ou "parada".
- Campo de busca com debounce (~250ms) que chama `functions.googlePlacesAutocomplete(query)` e atualiza `_model.predictions`.
- Não há chamada ao Google Place Details para construir um `FFPlace` completo (lat, lng, endereço formatado, cidade, nome).
- Chamadores (ex.: tela principal do passageiro) usam `context.pushNamed` sem `await`, portanto não recebem o resultado da busca.
- `MainPassageiroModel` armazena paradas como `List<String>`, sem suporte a `FFPlace` para origem/destino/paradas.
- Já existe suporte de serialização/deserialização de `FFPlace` em `flutter_flow/serialization_util.dart` (funções `serializeParam`, `deserializeParam`, `placeToString`, `placeFromString`).

Arquivos relevantes:
- Tela de busca: `lib/mai_passageiro_option/search_screen/search_screen_widget.dart` e `search_screen_model.dart`
- Funções customizadas: `lib/flutter_flow/custom_functions.dart` (tem `googlePlacesAutocomplete`)
- Tipo de local: `lib/flutter_flow/place.dart` (`FFPlace`)
- Serialização: `lib/flutter_flow/serialization_util.dart`
- Rotas: `lib/flutter_flow/nav/nav.dart` (rota `SearchScreenWidget`, param `origemDestinoParada`)
- Chamador passageiro: `lib/mai_passageiro_option/main_passageiro/main_passageiro_widget.dart`
- Modelo: `lib/mai_passageiro_option/main_passageiro/main_passageiro_model.dart`

## Lacunas Identificadas
1. Ausência de função de Place Details para construir `FFPlace` completo a partir de `place_id`.
2. `SearchScreen` não dá `pop` retornando o resultado selecionado.
3. Chamadores não aguardam (`await`) o retorno de `pushNamed` e, portanto, não recebem o `FFPlace`.
4. `MainPassageiroModel` não possui campos para guardar `origemPlace`, `destinoPlace` e `paradas` como `List<FFPlace>`.

## Decisões e Padrões
- Representar todos os pontos (origem, destino, paradas) com `FFPlace`.
- Obter `FFPlace` via Google Place Details usando a `place_id` de uma previsão do Autocomplete.
- Retornar o resultado da SearchScreen usando `context.pop(result)`. O chamador usa `final result = await context.pushNamed(...)`.
- Serializar quando for necessário transportar via rotas; armazenar em memória (modelo) como `FFPlace` diretamente.

## Plano de Implementação (passo a passo)
1) Função Place Details
- Adicionar em `custom_functions.dart` uma função `Future<FFPlace?> googlePlaceDetails(String placeId)` que:
  - Chama a Places Details API (campos: name, formatted_address, geometry/location, etc.).
  - Monta e retorna um `FFPlace` com: `name`, `address`, `city` (pode reusar utilitários existentes), `latLng` (tipo `LatLng`).
  - Tratar erros e resultados vazios com `null`.

2) Retorno de resultado na SearchScreen
- No `onTap` do item de previsão:
  - Buscar detalhes com `googlePlaceDetails(prediction.placeId)`.
  - Se obtiver `FFPlace`, chamar `context.pop(ffPlace)` para retornar à tela chamadora.
  - Opcional: exibir feedback de carregamento ao buscar detalhes.

3) Ajustes no chamador (MainPassageiro)
- Botões “Partida”, “Destino” e “Adicionar parada” devem `await context.pushNamed('SearchScreen', queryParams: { 'origemDestinoParada': '...' })`.
- Receber `final FFPlace? result = await ...;` e, se não nulo:
  - Se origem: salvar em `model.origemPlace`.
  - Se destino: salvar em `model.destinoPlace`.
  - Se parada: `model.paradasPlace.add(result)` (limitar a 4 paradas como já existe na UI).
- Atualizar a UI para exibir `name`/`address` dos `FFPlace` armazenados.

4) Atualizar o MainPassageiroModel
- Adicionar campos:
  - `FFPlace? origemPlace;`
  - `FFPlace? destinoPlace;`
  - `List<FFPlace> paradasPlace = [];`
- Métodos auxiliares: adicionar/atualizar/remover paradas; limpar origem/destino.

5) Serialização (quando necessário)
- Para transporte em rotas ou persistência temporária, usar `serializeParam(ffPlace)`. Para recuperar, `deserializeParam<FFPlace>(...)`.
- Para tela de escolha/espera de motorista que precise receber locais pelas rotas, seguir o padrão existente em `serialization_util.dart`.

6) Testes manuais (MVP)
- Buscar e selecionar origem: volta com `FFPlace` e preenche na tela principal.
- Repetir para destino e adicionar 1-4 paradas.
- Remover paradas e trocar origem/destino.
- Cenários de erro: sem internet, API Key inválida, Place Details não encontrado.

## Estrutura de Dados (`FFPlace`)
- `name`: título exibível (ex.: nome do local ou via/numero)
- `address`: endereço formatado para exibição
- `city`: cidade extraída do geocoding/details (opcional mas recomendado)
- `latLng`: coordenadas (`LatLng(lat, lng)`) para cálculos/rotas

## Riscos e Considerações
- Cotas e latência das APIs do Google (Autocomplete/Details).
- Debounce adequado para não exceder limite de requisições.
- Manter a API Key no `.env` e nunca em logs/commits.
- Comportamento em Web vs. Mobile para geolocalização e sugestões.

## Próximos Passos Relacionados
- Integrar a criação de `trip_request` após origem/destino definidos.
- Preparar estimativa de preço/ETA no client para exibição pré-solicitação.
- Iniciar fluxo de matching (candidatos, tempo de oferta, rota de fallback).
- Assinar updates Realtime para refletir aceitação/atribuição de motorista.

## Checklist de Aceite
- [ ] SearchScreen retorna um `FFPlace` via `context.pop`.
- [ ] Chamadores aguardam (`await`) e recebem o `FFPlace`.
- [ ] Origem, destino e paradas armazenados como `FFPlace` no `MainPassageiroModel`.
- [ ] UI atualiza com os valores selecionados.
- [ ] Erros de rede/API tratados com feedback ao usuário.