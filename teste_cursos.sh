#!/bin/bash

# [FLUXO] Script de testes e apresentacao da API Binario Cursos

API="http://localhost:1129"

# [TRANSF] Configuracao de cores para o terminal
VERDE="\033[32m"
VERMELHO="\033[31m"
AZUL="\033[34m"
RESET="\033[0m"

clear

# [FLUXO] Executa requisicoes HTTP e recebe as respostas da API
requisicao() {
    resposta=$(curl -sS --max-time 10 -w "\n%{http_code}" "$@")
    HTTP_CODE=$(echo "$resposta" | tail -n 1)
    BODY=$(echo "$resposta" | sed '$d')

    # [ERRO] Verifica se a API esta indisponivel
    if [[ "$HTTP_CODE" == "000" ]]; then
        echo -e "${VERMELHO}Erro: API indisponivel.${RESET}"
    else
        # [TRANSF] Exibe o status HTTP e formata o JSON
        echo -e "${AZUL}HTTP: $HTTP_CODE${RESET}"
        echo "$BODY" | jq .
    fi
}

# [FLUXO] Busca cursos e permite selecionar um curso pelo menu
selecionar_curso() {
    cursos=$(curl -sS "$API/cursos")

    # [ERRO] Valida se existem cursos cadastrados
    if ! echo "$cursos" | jq -e 'type == "array" and length > 0' >/dev/null; then
        echo -e "${VERMELHO}Nenhum curso encontrado.${RESET}"
        return 1
    fi

    # [TRANSF] Organiza os cursos em uma lista numerada
    echo "$cursos" | jq -r 'to_entries[] | "\(.key + 1) - \(.value.nome)"'
    read -p "Escolha o curso: " n

    # [ERRO] Valida a opcao escolhida pelo usuario
    if ! [[ "$n" =~ ^[0-9]+$ ]] || (( n < 1 || n > $(echo "$cursos" | jq 'length') )); then
        echo -e "${VERMELHO}Opcao invalida.${RESET}"
        return 1
    fi

    # [TRANSF] Converte a opcao numerica no ID do curso
    ID=$(echo "$cursos" | jq -r ".[$((n-1))]._id")
}

# [FLUXO] Busca matriculas e permite selecionar uma matricula pelo menu
selecionar_matricula() {
    matriculas=$(curl -sS "$API/matriculas")

    # [ERRO] Valida se existem matriculas cadastradas
    if ! echo "$matriculas" | jq -e 'type == "array" and length > 0' >/dev/null; then
        echo -e "${VERMELHO}Nenhuma matricula encontrada.${RESET}"
        return 1
    fi

    # [TRANSF] Organiza as matriculas em uma lista numerada
    echo "$matriculas" | jq -r 'to_entries[] | "\(.key + 1) - \(.value.nomeAluno)"'
    read -p "Escolha a matricula: " n

    # [ERRO] Valida a opcao escolhida pelo usuario
    if ! [[ "$n" =~ ^[0-9]+$ ]] || (( n < 1 || n > $(echo "$matriculas" | jq 'length') )); then
        echo -e "${VERMELHO}Opcao invalida.${RESET}"
        return 1
    fi

    # [TRANSF] Converte a opcao numerica no ID da matricula
    ID=$(echo "$matriculas" | jq -r ".[$((n-1))]._id")
}

# [FLUXO] Menu principal de operacoes da API
while true; do
    clear

    echo
    echo -e "${AZUL}===== BINARIO CURSOS =====${RESET}"
    echo "1 - Listar cursos"
    echo "2 - Cadastrar curso"
    echo "3 - Atualizar curso"
    echo "4 - Excluir curso"
    echo "5 - Listar matriculas"
    echo "6 - Cadastrar matricula"
    echo "7 - Atualizar matricula"
    echo "8 - Excluir matricula"
    echo "0 - Sair"

    read -p "Escolha: " opcao

    # [TRANSF] Direciona a operacao conforme a opcao selecionada
    case $opcao in

        # [FLUXO] Consulta todos os cursos cadastrados
        1)
            requisicao "$API/cursos"
            ;;

        # [FLUXO] Recebe os dados para cadastrar um curso
        2)
            read -p "Nome: " nome
            read -p "Descricao: " descricao

            # [ERRO] Valida a carga horaria informada
            while true; do
                read -p "Carga horaria: " carga

                if [[ "$carga" =~ ^[0-9]+$ ]] && (( carga > 0 )); then
                    break
                fi

                echo -e "${VERMELHO}Digite um numero positivo.${RESET}"
            done

            read -p "Categoria: " categoria
            read -p "Instrutor: " instrutor
            # [TRANSF] Construi o JSON com os dados do curso
            dados=$(jq -n \
                --arg nome "$nome" \
                --arg descricao "$descricao" \
                --arg categoria "$categoria" \
                --arg instrutor "$instrutor" \
                --argjson cargaHoraria "$carga" \
                '{nome:$nome, descricao:$descricao, cargaHoraria:$cargaHoraria, categoria:$categoria, instrutor:$instrutor}')

            # [FLUXO] Envia os dados para cadastro na API
            requisicao -X POST "$API/cursos" -H "Content-Type: application/json" -d "$dados"
            ;;

        # [FLUXO] Atualiza o status de um curso
        3)
            selecionar_curso || continue

            echo "1 - Ativo"
            echo "2 - Inativo"
            read -p "Status: " s

            # [TRANSF] Converte a opcao para o status correspondente
            if [[ "$s" == "1" ]]; then
                status="Ativo"
            elif [[ "$s" == "2" ]]; then
                status="Inativo"
            else
                # [ERRO] Opcao de status invalida
                echo -e "${VERMELHO}Opcao invalida.${RESET}"
                continue
            fi

            # [TRANSF] Monta o JSON para atualizar o curso
            dados=$(jq -n --arg status "$status" '{status:$status}')
            # [FLUXO] Envia a atualizacao para a API
            requisicao -X PATCH "$API/cursos/$ID" -H "Content-Type: application/json" -d "$dados"
            ;;

        # [FLUXO] Exclui um curso selecionado
        4)
            selecionar_curso || continue
            read -p "Confirmar exclusao? (s/n): " confirmar
            # [ERRO] Confirma a exclusao antes de executar
            if [[ "$confirmar" == "s" || "$confirmar" == "S" ]]; then
                requisicao -X DELETE "$API/cursos/$ID"
            fi
            ;;

        # [FLUXO] Consulta todas as matriculas cadastradas
        5)
            requisicao "$API/matriculas"
            ;;

        # [FLUXO] Recebe dados para cadastrar uma matricula
        6)
            read -p "Nome do aluno: " nomeAluno
            read -p "Email: " emailAluno

            echo "Escolha o curso:"
            selecionar_curso || continue
            # [TRANSF] Monta o JSON relacionando aluno e curso
            dados=$(jq -n \
                --arg nomeAluno "$nomeAluno" \
                --arg emailAluno "$emailAluno" \
                --arg curso "$ID" \
                '{nomeAluno:$nomeAluno, emailAluno:$emailAluno, curso:$curso}')

            # [FLUXO] Envia os dados da matricula para a API
            requisicao -X POST "$API/matriculas" -H "Content-Type: application/json" -d "$dados"
            ;;

        # [FLUXO] Atualiza o status de uma matricula
        7)
            selecionar_matricula || continue
            echo "1 - ATIVA"
            echo "2 - TRANCADA"
            echo "3 - CANCELADA"
            echo "4 - SUSPENSA"
            echo "5 - CONCLUIDA"

            read -p "Status: " s
            # [TRANSF] Converte a opcao para o status correspondente
            case $s in
                1) status="ATIVA" ;;
                2) status="TRANCADA" ;;
                3) status="CANCELADA" ;;
                4) status="SUSPENSA" ;;
                5) status="CONCLUIDA" ;;
                *)
                    # [ERRO] Status invalido
                    echo -e "${VERMELHO}Opcao invalida.${RESET}"
                    continue
                    ;;
            esac

            # [TRANSF] Monta o JSON com o novo status
            dados=$(jq -n --arg status "$status" '{status:$status}')

	    # [FLUXO] Envia a atualizacao para a API
            requisicao -X PATCH "$API/matriculas/$ID" -H "Content-Type: application/json" -d "$dados"
            ;;

        # [FLUXO] Exclui uma matricula selecionada
        8)
            selecionar_matricula || continue
            read -p "Confirmar exclusao? (s/n): " confirmar

            # [ERRO] Confirma a exclusao antes de executar
            if [[ "$confirmar" == "s" || "$confirmar" == "S" ]]; then
                requisicao -X DELETE "$API/matriculas/$ID"
            fi
            ;;

        # [FLUXO] Encerra a apresentacao
        0)
            clear
            echo -e "${VERDE}Encerrando apresentacao...${RESET}"
            break
            ;;
        # [ERRO] Trata opcao inexistente no menu principal
        *)
            echo -e "${VERMELHO}Opcao invalida.${RESET}"
            ;;
    esac

    read -p "Pressione ENTER para voltar ao menu..."
    clear
done
