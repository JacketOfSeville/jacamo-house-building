// Empresa de preparação de site

{ include("common.asl") }

// Crenças iniciais para cada tipo de leilão
my_price("SitePreparation", 1000).

// Ativa o agente para começar a leiloar para a tarefa de preparação de site
!discover_art("auction_for_SitePreparation").

//Detecta se há um novo valor para o lance atual
+currentBid(V)[artifact_id(Art)]  
    // Se a tarefa for a preparação do solo
    : task("SitePreparation")[artifact_id(Art)] &
      
      // Poder oferecer um preço melhor na tarefa
      my_price("SitePreparation",P) &

      // Não estiver ganhando
      not i_am_winning(Art) & 

      // onde V é o valor do maior lance atual, 
      // e é maior que P
      P < V        
                  
   <- .print("My bid in artifact ", Art, ", at Task SitePreparation, is ", P);
      bid( P )[ artifact_id(Art) ].

// Estratégia de lance: lance 10% abaixo do preço máximo
+!bid_strategy
   <- ?currentBid(V)[artifact_id(Art)] &
      my_price("SitePreparation",P) &
      NewBid = P - (P * 0.1) &
      bid( NewBid )[ artifact_id(Art) ].

/* planos para fase de execução */

{ include("org_code.asl") }
{ include("org_goals.asl") }