// Esta empresa oferece propostas para todas as tarefas
// Estratégia: oferece um valor aleatório

{ include("comum.asl") }

// Ativa o agente para começar a leiloar para cada tarefa abaixo
!discover_art("auction_for_SitePreparation").
!discover_art("auction_for_Floors").
!discover_art("auction_for_Walls").
!discover_art("auction_for_Roof").
!discover_art("auction_for_WindowsDoors").
!discover_art("auction_for_Plumbing").
!discover_art("auction_for_ElectricalSystem").
!discover_art("auction_for_Painting").

// O gatilho para o plano, significando que
// o agente recebeu a tarefa 'S' associada ao
// artefator Art
+task(S)[artifact_id(Art)]

   // O agente espera por um tempo aleatório entre 50ms e 550ms 
   // antes de proceder com o resto do plano
   // Acaba introduzindo aleatoriedade no processo de leilão
   <- .wait(math.random(500)+50);

      // Gera um lance de valor aleatório entre 800 e 10799 e o arredondando para baixo
      Bid = math.floor(math.random(10000))+800;
      
      // Imprime que o agente irá fazer o lance
      // no artefato atual, Art
      .print("My bid in artifact ", Art, " is ",Bid);

      // Realza o lance para o serviço
     !bid(Art,.my_name, Bid).

/* planos para fase de execução */

{ include("emp_code.asl") }
{ include("emp_goals.asl") }