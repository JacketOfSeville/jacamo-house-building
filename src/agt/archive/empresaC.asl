// Esta empresa pode concorrer a todos os tipos de tarefas,
// mas pode comprometer-se com no máximo 2 deles
// Estratégia: preço fixo

{ include("comum.asl") }

// Determina a regra em que o agente poderá ou não
// participar em outra tarefa
can_commit :-
   .my_name(Me) & .term2string(Me,MeS) &
   .findall( ArtId, obsProperty(ArtId, "winner", MeS), L) &
   .length(L,S) & S < 2.

// Crenças iniciais para cada tipo de leilão
my_price("SitePreparation", 1900).
my_price("Floors",           900).
my_price("Walls",            900).
my_price("Roof",            1100).
my_price("WindowsDoors",    2000).
my_price("Plumbing",         600).
my_price("ElectricalSystem", 300).
my_price("Painting",        1100).

// Ativa o agente para começar a leiloar para cada tarefa acima
!discover_art("auction_for_SitePreparation").
!discover_art("auction_for_Floors").
!discover_art("auction_for_Walls").
!discover_art("auction_for_Roof").
!discover_art("auction_for_WindowsDoors").
!discover_art("auction_for_Plumbing").
!discover_art("auction_for_ElectricalSystem").
!discover_art("auction_for_Painting").

// Atômico: Garante que ainda ganhe menos de dois quando o lance for feito
@[atomic]

//Detecta se há um novo valor para o lance atual
+currentPrice(V)[artifact_id(Art)]  

    // Se o agente possui a tarefa 'S' 
    // associada ao artefato Art, e
    : task(S)[artifact_id(Art)] &

      // o agente possui um preço 'P' para a tarefa 'S', e
      my_price(S,P) &

      // o agente não é o vencedor atual do leilão, e
      not i_am_winning(Art) & 

      // o valor a ser leiloado é menor que o lance atual, e
      P < V &            

      // (Baseado na regra anterior)
      // o agente pode se comprometer com outra tarefa
      can_commit                   

      // Impeime que o agente irá fazer um lance
      // no Artefato atual, na tarefa atual
   <- .print("My bid in artifact ", Art, ", at Task ", S, ", is ", P);

      // Faz o lance em que oferece o serviço
      // mais barato em relação ao anterior
      !bid(Art, .my_name, P).

// Detecta se o agente é o vencedor atual do leilão
+i_am_winning(Art)[artifact_id(Art)]
    : obsProperty(Art, "winner", .my_name).

// plano para executar metas organizacionais
+!goal_reached(Art)[artifact_id(Art)]
    : obsProperty(Art, "winner", .my_name) &
      obsProperty(Art, "auctionState", "closed")
   <- !accept(Art, .my_name).

{ include("emp_code.asl") }
{ include("emp_goals.asl") }