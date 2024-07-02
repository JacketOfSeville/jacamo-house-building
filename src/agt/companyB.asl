// Esta empresa licita para preparação do local
// Estratégia: diminuir seu preço em 150 até seu valor mínimo

{ include("common.asl") }

// Crença inicial, em que seu preço é 1500
my_price(1500).

// Evento que ativa o agente para começar a leiloar
!discover_art("auction_for_SitePreparation").

// Detecta se há um valor novo para o lance atual
+currentBid(V)[artifact_id(Art)]

    // Se o agente não é o vencedor atual do leilão
    : not i_am_winning(Art) & 

      // e ele pode oferecer um lance melhor, 
      // onde V é o valor do maior lance atual, 
      // e é maior que P
      my_price(P) & P < V       

      // Imprime que o agente irá fazer um lance
      // no artefato atual         
   <- .print("My bid in artifact ", Art, " is ",math.max(V-150,P));
      
      // Faz o lance em que oferece o serviço
      // mais barato em relação ao anterior.
      // Neste caso, escolhe o maior valor entre
      // seu preço da crença inicial, e o valor
      // atual do lance - 150
      bid( math.max(V-150,P) ). 

/* planos para fase de execução */

{ include("org_code.asl") }

+!site_prepared
   <- prepareSite. // simula a ação (no artefato GUI)

