defmodule TicTacToe do
  def convertMoveToRowColumn(move) do
    case move do
      "1" -> { true, 0, 0 }
      "2" -> { true, 0, 1 }
      "3" -> { true, 0, 2 }
      "4" -> { true, 1, 0 }
      "5" -> { true, 1, 1 }
      "6" -> { true, 1, 2 }
      "7" -> { true, 2, 0 }
      "8" -> { true, 2, 1 }
      "9" -> { true, 2, 2 }
      _ -> { false, -1, -1 }
    end
  end

  def isMoveValid(row, col, board) do
    valueInCell = elem(elem(board,row), col)
    case valueInCell do
      :player1 ->
        IO.puts("Player 1 in this cell")
        false
      :player2 ->
        IO.puts("Player 2 in this cell")
        false
      :invalid ->
        IO.puts("Enter a number 1 to 9")
        false
      _ -> true
    end
  end

  def getMove(board) do
    # trim will remove the CR/LF from end of string
    move = String.trim(IO.gets("What is your move?"))
    {isValid, row, col} = convertMoveToRowColumn(move)
    case isValid do
      true ->
        case isMoveValid(row, col, board) do
          true ->
            IO.puts("Good move")
            { row, col }
          false ->
            IO.puts("Invalid move, try again")
            getMove(board)
        end
      _ ->
        IO.puts("Enter a number 1 to 9")
        getMove(board)
    end

  end

  def getCellOutput(cell) do
    case cell do
      :player1 ->
        "X"
      :player2 ->
        "Y"
      _ ->
        " "
    end
  end

  def getRowOutput(row) do
   "#{getCellOutput(elem(row,0))} | #{getCellOutput(elem(row,1))} | #{getCellOutput(elem(row,2))}"
  end

  def getDividerRow() do
    "---------"
  end

  def outputBoard(board) do
    IO.puts(getRowOutput(elem(board,0)))
    IO.puts(getDividerRow())
    IO.puts(getRowOutput(elem(board,1)))
    IO.puts(getDividerRow())
    IO.puts(getRowOutput(elem(board,2)))
  end


  def nextPlayer(currentPlayer) do
    case currentPlayer do
      :player1 ->
        IO.puts("Player 2's Turn")
        :player2
        # TODO - add computer move logic
      _ ->
        IO.puts("Player 1's Turn")
        :player1

    end
  end

  def savePlayerMove(player, row, col, board) do
    rowValues = elem(board, row)
    # get a new row with the new player value set
    updatedRow = put_elem(rowValues, col, player)
    # return new board, replacing the row that was updated
    put_elem(board, row, updatedRow)
  end

  def gameLoop(board, currentPlayer) do
    outputBoard(board)
    currentPlayer = nextPlayer(currentPlayer)
    { row, col } = getMove(board)
    board = savePlayerMove(currentPlayer, row, col, board)
    # TODO - put in logic to end game
    gameLoop(board, currentPlayer)
  end

  def startGame() do
    board = {
      { :empty, :empty, :empty},
      { :empty, :empty, :empty},
      { :empty, :empty, :empty},
    }
    # currentPlayer = :none;
    _playComputer = true;
    _gameOn = true;

    gameLoop(board, :none)
  end

end



TicTacToe.startGame()
