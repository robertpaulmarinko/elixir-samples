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

  def getCellValue(rowIndex, colIndex, board) do
    elem(elem(board,rowIndex), colIndex)
  end

  def isMoveValid(row, col, board) do
    valueInCell = getCellValue(row, col, board)
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

  def isRowAllOnePlayer(row) do
      row == {:player1, :player1, :player1} or row == {:player2, :player2, :player2}
  end

  def isColAllOnePlayer(colIndex, board) do
    colValues = Enum.map(Tuple.to_list(board), fn row -> elem(row,colIndex) end)
    colValues == [:player1, :player1, :player1] or colValues == [:player2, :player2, :player2]
  end

  def isDigonalAllOnePlayer(board) do
    centerCell = getCellValue(1,1,board)
    centerCell !== :empty and (
      (getCellValue(0,0,board) == centerCell and getCellValue(2,2,board) == centerCell)
      or
      (getCellValue(0,2,board) == centerCell and getCellValue(2,0,board) == centerCell)
    )
  end

  def areNoEmptyCells(board) do
    allValues = Enum.flat_map(Tuple.to_list(board), fn row -> Tuple.to_list(row) end)
    Enum.count(allValues, fn value -> value == :empty end) == 0
  end

  def checkForEndOfGame(board) do
    cond do
      isRowAllOnePlayer(elem(board,0)) -> { true, getCellValue(0,0,board)}
      isRowAllOnePlayer(elem(board,1)) -> { true, getCellValue(1,0,board)}
      isRowAllOnePlayer(elem(board,2)) -> { true, getCellValue(2,0,board)}
      isColAllOnePlayer(0, board) -> { true, getCellValue(0,0,board)}
      isColAllOnePlayer(1, board) -> { true, getCellValue(0,1,board)}
      isColAllOnePlayer(2, board) -> { true, getCellValue(0,2,board)}
      isDigonalAllOnePlayer(board) -> { true, getCellValue(1,1,board)}
      areNoEmptyCells(board) -> { true, :empty}
      true -> { false, :empty }
    end
  end

  def gameLoop(board, currentPlayer) do
    outputBoard(board)
    currentPlayer = nextPlayer(currentPlayer)
    { row, col } = getMove(board)
    board = savePlayerMove(currentPlayer, row, col, board)

    { isGameOver, winningPlayer } = checkForEndOfGame(board)
    case isGameOver do
      false -> gameLoop(board, currentPlayer)
      true ->
        case winningPlayer do
          :player1 -> IO.puts("Player 1 Won!")
          :player2 -> IO.puts("Player 2 Won!")
          :empty ->  IO.puts("Tie!")
        end
    end
  end

  def startGame() do
    board = {
      { :empty, :empty, :empty},
      { :empty, :empty, :empty},
      { :empty, :empty, :empty},
    }

    _playComputer = true;
    _gameOn = true;

    gameLoop(board, :none)
  end

end



TicTacToe.startGame()
