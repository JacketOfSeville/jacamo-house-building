// Agente Giacomo, que quer construir uma casa

{ include("common.asl") }

/* Crenças e regras iniciais */

// Define a regra que conta o número de tarefas com base nas propriedades observáveis ​​dos artefatos do leilão
number_of_tasks(NS) :- .findall( S, task(S), L) & .length(L,NS).

/* Initial goals */
// Define o objetivo atual de ter uma casa
!have_a_house.

/* Planos */

// O plano para alcançar o objetivo de ter uma casa, envolve
// a contratação de empresas para construir a casa e enfim,
// executar sua construção
+!have_a_house
   <- !contract; // contrata as empresas que vão construir a casa
      !execute;  // (simula) a execução da construção
   .

// O plano para lidar com erros ao construir a casa
-!have_a_house[error(E),error_msg(Msg),code(Cmd),code_src(Src),code_line(Line)]
   <- .print("Falha ao construir uma casa devido a: ",Msg," (",E,"). Commando: ",Cmd, " no ",Src,":", Line).


/* Planos de Contratação */

// O plano para a contratação de empresas, envolve a criação
// de artefatos de leilões e então esperar lances
+!contract
   <- !create_auction_artifacts;
      !wait_for_bids.
//      !dispose_auction_artifacts.

// O plano para criar o leilão para cada tarefa envolvida
// na construção da casa (ex: chão, paredes, etc.)
+!create_auction_artifacts
   <-  !create_auction_artifact("SitePreparation", 2000); // 2000 é o valor máximo que posso pagar pela tarefa
       !create_auction_artifact("Floors",          1000);
       !create_auction_artifact("Walls",           1000);
       !create_auction_artifact("Roof",            2000);
       !create_auction_artifact("WindowsDoors",    2500);
       !create_auction_artifact("Plumbing",         500);
       !create_auction_artifact("ElectricalSystem", 500);
       !create_auction_artifact("Painting",        1200).

// Plano para a criação de um único leilão para uma tarefa
// específica, com um preço máximo
+!create_auction_artifact(Task,MaxPrice)
   <- .concat("auction_for_",Task,ArtName); // Concatena a string com 'Task' e armazena em 'ArtName'
      makeArtifact(ArtName, "tools.AuctionArt", [Task, MaxPrice], ArtId); // cria o artefato com o nome, tarefa, preço e ID
      focus(ArtId). // Foca neste artefato

// Plano para contingência de error proferidos da criação do leilão
-!create_auction_artifact(Task,MaxPrice)[error_code(Code)]
   <- .print("Error creating artifact ", Code).

// Plano para aguardar por 5 segundos e então anunciar os ganhadores
+!wait_for_bids
   <- println("Waiting bids for 5 seconds...");
      .wait(5000); // utiliza um prazo interno de 5 segundos para fechar os leilões
      !show_winners.

// Plano para o anuncio de cada ganhador de cada tarefa
+!show_winners
   <- for ( currentWinner(Ag)[artifact_id(ArtId)] ) {
         ?currentBid(Price)[artifact_id(ArtId)]; // verifica o lance atual
         ?task(Task)[artifact_id(ArtId)];          // e a tarefa a que se destina
         println("Winner of task ", Task," is ", Ag, " for ", Price)
      }.

//+!dispose_auction_artifacts
//   <- for ( task(_)[artifact_id(ArtId)] ) {
//         stopFocus(ArtId)
//         //disposeArtifact(ArtId)
//      }.

/* Planos de gestão da execução da construção da casa */

// O plano de execução da construção da casa envolve a criação de um espaço
// de trabalho, entrada no espaço de trabalho, criar um comitê de organização,
// criar um grupo e contratar os vencedores
+!execute
   <- println;
      println("*** Execution Phase ***");
      println;

      // Criação do grupo
      .my_name(Me);
      createWorkspace("ora4mas");
      joinWorkspace("ora4mas",WOrg);

      // Obs.: nós (temos que) usar o mesmo id para OrgBoard e Workspace (ora4mas neste exemplo)
      makeArtifact(ora4mas, "ora4mas.nopl.OrgBoard", ["src/org/house-os.xml"], OrgArtId)[wid(WOrg)];
      focus(OrgArtId);
      createGroup(hsh_group, house_group, GrArtId);
      debug(inspector_gui(on))[artifact_id(GrArtId)];
      adoptRole(house_owner)[artifact_id(GrArtId)];
      focus(GrArtId);

      !contract_winners("hsh_group"); // eles entrarão no grupo

      // cria o artefato GUI
      makeArtifact("housegui", "simulator.House");

      // cria o scheme
      createScheme(bhsch, build_house_sch, SchArtId);
      debug(inspector_gui(on))[artifact_id(SchArtId)];
      focus(SchArtId);

      ?formationStatus(ok)[artifact_id(GrArtId)]; // veja o plano abaixo para garantir que esperaremos até que esteja bem formado
      addScheme("bhsch")[artifact_id(GrArtId)];
      commitMission("management_of_house_building")[artifact_id(SchArtId)].

// O plano para contratar os vencedores e adicioná-los ao grupo
+!contract_winners(GroupName)
    : number_of_tasks(NS) &
      .findall( ArtId, currentWinner(A)[artifact_id(ArtId)] & A \== "no_winner", L) &
      .length(L, NS)
   <- for ( currentWinner(Ag)[artifact_id(ArtId)] ) {
            ?task(Task)[artifact_id(ArtId)];
            println("Contracting ",Ag," for ", Task);
            .send(Ag, achieve, contract(Task,GroupName)) //envia a mensagem ao agente avisando sobre o resultado
      }.

// Plano para contingência de erros caso falhe ao 
// encontrar construtores suficientes
+!contract_winners(_)
   <- println("** I didn't find enough builders!");
      .fail.

// planeja esperar até que o grupo esteja bem formado
// suspende esta intenção até que se acredite que o grupo esteja bem formado
+?formationStatus(ok)[artifact_id(G)]
   <- .wait({+formationStatus(ok)[artifact_id(G)]}).

// Plano para conquistar o objetivo de construir a casa
+!house_built // Tenho uma obrigação em relação ao objetivo de nível superior do esquema: terminar!
   <- println("*** Finalizado ***").
