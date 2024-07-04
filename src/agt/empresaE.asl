// Esta empresa licita pisos, paredes e telhados
// Estratégia: um preço fixo mais baixo para realizar todas as 3 tarefas,
// diminui o lance atual em um valor fixo

{ include("comum.asl") }

// Crença para o preço mínimo para as 3 tarefas
my_price(800).

// Define uma regra que calcula a soma dos lances atuais feitos por este agente
sum_of_my_offers(S) :-
   .my_name(Me) & .term2string(Me,MeS) &
   .findall( V, obsProperty(ArtId, "winner", MeS) & obsProperty(ArtId, "currentPrice", V), L) &
   S = math.sum(L).

/* Planos para fase de leilão */

// Ativa o agente para começar a leiloar para cada tarefa abaixo
!discover_art("auction_for_Floors").
!discover_art("auction_for_Walls").
!discover_art("auction_for_Roof").

// É ativado quando detecta um novo lance para um artefato Art
+currentPrice(V)[artifact_id(Art)]

    // Se o agente não é o vencedor atual do leilão,
    : not i_am_winning(Art) &

      // o agente possui um valor mínimo para a tarefa,
      my_price(P) &

      // o agente calculou a soma de seus lances,
      sum_of_my_offers(Sum) &

      // o agente tem a tarefa 'S' associada ao artefato Art, e
      task(S)[artifact_id(Art)] &

      // O preço mínimo do agente é menor que a soma de 
      // seus lances atuais + o lance atual
      P < Sum + V    

      // Imprime que o agente irá fazer um lance
      // no artefato Art, na tarefa 'S'
   <- .print("My bid in artifact ", Art, ", at Task ", S,", is ",math.max(V-10,P));

      // Faz o lance em que oferece o serviço mais barato
      // em relação ao anterior, onde o preço é o máximo
      // do lance atual, menos 10 e o preço mínimo do agente 'P'
      !bid(Art, .my_name, math.max(V-10,P)).

/* planos para fase de execução */

{ include("emp_code.asl") }
{ include("emp_goals.asl") }