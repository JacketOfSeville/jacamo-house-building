{ include("common.asl") }

my_price(200).

sum_of_my_offers(S) :-
   .my_name(Me) & .term2string(Me,MeS) &
   .findall( V,      // encontra os leilões em que está ganhando
             currentWinner(MeS)[artifact_id(ArtId)] &
             currentBid(V)[artifact_id(ArtId)],
             L) &
   S = math.sum(L).

!discover_art("auction_for_Floors").
!discover_art("auction_for_Walls").
!discover_art("auction_for_Roof").


+currentBid(V)[artifact_id(Art)]      // há um novo valor para o lance atual
    : not i_am_winning(Art) &         // se eu não sou o vencedor
      my_price(P) &
      sum_of_my_offers(Sum) & 
      task(S)[artifact_id(Art)] &
      P < Sum + V                     // e Ainda posso oferecer um lance melhor
   <- //.print("Meu lance no artefato ", Art, ", Task ", S,", é ",math.max(V-10,P));
      bid( math.max(V-10,P) )[ artifact_id(Art) ].  // faço meu lance oferecendo um serviço mais barato

/* planos para fase de execução */

{ include("org_code.asl") }
{ include("org_goals.asl") }
