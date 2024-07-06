// Esta empresa licita para preparação do local
// Estratégia: diminuir seu preço em 150 até seu valor mínimo

{ include("comum.asl") }

// Crença inicial, em que seu preço é 1500
my_price(1500).

// Evento que ativa o agente para começar a leiloar
!discover_art("auction_for_SitePreparation").

// Detecta se há um novo valor para o lance atual
+currentPrice(V)[artifact_id(Art)]
    : obsProperty(Art, "currentPrice", V) &
      not i_am_winning(Art) &
      my_price(P) & P > V
   <- .print("My bid in artifact ", Art, " is ", math.max(V-150,P));
      !bid(Art, .my_name, math.max(V-150,P)).

// Detecta se o agente é o vencedor atual do leilão
+i_am_winning(Art)[artifact_id(Art)]
    : obsProperty(Art, "winner", .my_name).

// plano para executar metas organizacionais
+!site_prepared   // Objetivo da organização (criado a partir de uma obrigação)
   <- prepareSite. // simula a ação (no artefato GUI)

// plano para aceitar o contrato
+!contract_accepted(Art)[artifact_id(Art)]
    : obsProperty(Art, "winner", .my_name) &
      obsProperty(Art, "auctionState", "closed")
   <- !accept(Art, .my_name).

{ include("emp_code.asl") }