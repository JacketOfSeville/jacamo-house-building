// Esta empresa licita apenas para encanamento
// Estratégia: preço fixo

{ include("comum.asl") }

// Crença inicial, em que seu preço é 300
my_price(300).

// Evento que ativa o agente para começar a leiloar
!discover_art("auction_for_Plumbing").

// Detecta se há um novo valor para o lance atual
+currentPrice(V)[artifact_id(Art)]
    : obsProperty(Art, "currentPrice", V) &
      not i_am_winning(Art) &
      my_price(P) & P > V
   <- .print("My bid in artifact ", Art, " is ",P);
      !bid(Art, .my_name).

// Detecta se o agente é o vencedor atual do leilão
+i_am_winning(Art)[artifact_id(Art)]
    : obsProperty(Art, "winner", .my_name).

// plano para executar metas organizacionais
+!plumbing_installed   // Objetivo da organização (criado a partir de uma obrigação)
   <- installPlumbing. // simula a ação (no GUI artifact)

// plano para aceitar o contrato
+!contract_accepted(Art)[artifact_id(Art)]
    : obsProperty(Art, "winner", .my_name) &
      obsProperty(Art, "auctionState", "closed")
   <- !accept(Art, .my_name).

{ include("emp_code.asl") }