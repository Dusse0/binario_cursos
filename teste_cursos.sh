#!/bin/bash
#
API="http://localhost:1129"

# Cores
VERDE="\033[32m"
VERMELHO="\033[31m"
AZUL="\033[34m"
RESET="\033[0m"

clear

# Requisicao HTTP
requisicao() {
    resposta=$(curl -sS --max-time 10 -w "\n%{http_code}" "$@")
    HTTP_CODE=$(echo "$resposta" | tail -n 1)
    BODY=$(echo "$resposta" | sed '$d')

    if [[ "$HTTP_CODE" == "000" ]]; then
        echo -e "${VERMELHO}Erro: API indisponivel.${RESET}"
    else
        echo -e "${AZUL}HTTP: $HTTP_CODE${RESET}"
        echo "$BODY" | jq .
    fi
}

# Selecionar curso
selecionar_curso() {
    cursos=$(curl -sS "$API/cursos")

    if ! echo "$cursos" | jq -e 'type == "array" and length > 0' >/dev/null; then
        echo -e "${VERMELHO}Nenhum curso encontrado.${RESET}"
        return 1
    fi

    echo "$cursos" | jq -r 'to_entries[] | "\(.key + 1) - \(.value.nome)"'
    read -p "Escolha o curso: " n

    if ! [[ "$n" =~ ^[0-9]+$ ]] || (( n < 1 || n > $(echo "$cursos" | jq 'length') )); then
        echo -e "${VERMELHO}Opcao invalida.${RESET}"
        return 1
    fi

    ID=$(echo "$cursos" | jq -r ".[$((n-1))]._id")
}

# Selecionar matricula
selecionar_matricula() {
    matriculas=$(curl -sS "$API/matriculas")

    if ! echo "$matriculas" | jq -e 'type == "array" and length > 0' >/dev/null; then
        echo -e "${VERMELHO}Nenhuma matricula encontrada.${RESET}"
        return 1
    fi

    echo "$matriculas" | jq -r 'to_entries[] | "\(.key + 1) - \(.value.nomeAluno)"'
    read -p "Escolha a matricula: " n

    if ! [[ "$n" =~ ^[0-9]+$ ]] || (( n < 1 || n > $(echo "$matriculas" | jq 'length') )); then
        echo -e "${VERMELHO}Opcao invalida.${RESET}"
        return 1
    fi

    ID=$(echo "$matriculas" | jq -r ".[$((n-1))]._id")
}

# Menu
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
    case $opcao in

        1)
            requisicao "$API/cursos"
            ;;

        2)
            read -p "Nome: " nome
            read -p "Descricao: " descricao
            while true; do
                read -p "Carga horaria: " carga

                if [[ "$carga" =~ ^[0-9]+$ ]] && (( carga > 0 )); then
                    break
                fi

                echo -e "${VERMELHO}Digite um numero positivo.${RESET}"
            done

            read -p "Categoria: " categoria
            read -p "Instrutor: " instrutor
            dados=$(jq -n \
                --arg nome "$nome" \
                --arg descricao "$descricao" \
                --arg categoria "$categoria" \
                --arg instrutor "$instrutor" \
                --argjson cargaHoraria "$carga" \
                '{nome:$nome, descricao:$descricao, cargaHoraria:$cargaHoraria, categoria:$categoria, instrutor:$instrutor}')

            requisicao -X POST "$API/cursos" -H "Content-Type: application/json" -d "$dados"
            ;;

        3)
            selecionar_curso || continue
            echo "1 - Ativo"
            echo "2 - Inativo"
            read -p "Status: " s

            if [[ "$s" == "1" ]]; then
                status="Ativo"
            elif [[ "$s" == "2" ]]; then
                status="Inativo"
            else
                echo -e "${VERMELHO}Opcao invalida.${RESET}"
                continue
            fi

            dados=$(jq -n --arg status "$status" '{status:$status}')

            requisicao -X PATCH "$API/cursos/$ID" -H "Content-Type: application/json" -d "$dados"
            ;;

        4)
            selecionar_curso || continue
            read -p "Confirmar exclusao? (s/n): " confirmar

            if [[ "$confirmar" == "s" || "$confirmar" == "S" ]]; then
                requisicao -X DELETE "$API/cursos/$ID"
            fi
            ;;

        5)
            requisicao "$API/matriculas"
            ;;

        6)
            read -p "Nome do aluno: " nomeAluno
            read -p "Email: " emailAluno

            echo "Escolha o curso:"
            selecionar_curso || continue
            dados=$(jq -n \
                --arg nomeAluno "$nomeAluno" \
                --arg emailAluno "$emailAluno" \
                --arg curso "$ID" \
                '{nomeAluno:$nomeAluno, emailAluno:$emailAluno, curso:$curso}')
            requisicao -X POST "$API/matriculas" -H "Content-Type: application/json" -d "$dados"
            ;;

        7)
            selecionar_matricula || continue
            echo "1 - ATIVA"
            echo "2 - TRANCADA"
            echo "3 - CANCELADA"
            echo "4 - SUSPENSA"
            echo "5 - CONCLUIDA"

            read -p "Status: " s

            case $s in
                1) status="ATIVA" ;;
                2) status="TRANCADA" ;;
                3) status="CANCELADA" ;;
                4) status="SUSPENSA" ;;
                5) status="CONCLUIDA" ;;
                *) echo -e "${VERMELHO}Opcao invalida.${RESET}"; continue ;;
            esac
            dados=$(jq -n --arg status "$status" '{status:$status}')
            requisicao -X PATCH "$API/matriculas/$ID" -H "Content-Type: application/json" -d "$dados"
            ;;

        8)
            selecionar_matricula || continue
            read -p "Confirmar exclusao? (s/n): " confirmar

            if [[ "$confirmar" == "s" || "$confirmar" == "S" ]]; then
                requisicao -X DELETE "$API/matriculas/$ID"
            fi
            ;;

        0)
            clear
            echo -e "${VERDE}Encerrando apresentacao...${RESET}"
            break
            ;;
        *)
            echo -e "${VERMELHO}Opcao invalida.${RESET}"
            ;;
    esac

    read -p "Pressione ENTER para voltar ao menu..."
    clear
done
