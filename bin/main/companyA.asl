// Esta empresa licita apenas para encanamento
// Estratégia: preço fixo

{ include("common.asl") }

// Crença inicial, em que seu preço é 300
my_price(300).

// Evento que ativa o agente para começar a leiloar
!discover_art("auction_for_Plumbing").

// Detecta se há um novo valor para o lance atual
+currentBid(V)[artifact_id(Art)]

    // Se o agente não é o vencedor atual do leilão
    : not i_am_winning(Art)  & 
      
      // e ele pode oferecer um lance melhor, 
      // onde V é o valor do maior lance atual, 
      // e é maior que P
      my_price(P) & P < V 

      // Imprime que o agente irá fazer um lance
      // no artefato atual 
   <- .print("My bid in artifact ", Art, " is ",P);

      // Faz o lance em que oferece o serviço
      // mais barato em relação ao anterior
      bid( P ).

/* planos para fase de execução */

{ include("org_code.asl") }

// plano para executar metas organizacionais (não implementado)

+!plumbing_installed   // Objetivo da organização (criado a partir de uma obrigação)
   <- installPlumbing. // simula a ação (no GUI artifact)

