defmodule JuegoMago do

  @puertas [:p1, :p2, :p3, :p4, :p5, :p6, :p7, :p8, :p9, :p10]
  @premios [50, 100, 200, nil, nil, nil, 0, 0, 0, 0]

  def concursar do

    puertasLista = @puertas
    premios = Enum.shuffle(@premios)
    puertas_premios = puertasLista |> Enum.zip(premios) |> Enum.into(%{})
    IO.inspect(puertas_premios)
    puertas = %Puertas{}
    resultado = %Resultado{}
    puerta_vacia = 0
    puertas_string = "P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 | P9 | P10"
    resultado = ronda(puertas, puertas_premios, resultado, puerta_vacia, puertas_string, 1)
    IO.inspect(resultado)

  end

  def ronda(puertas, puertas_premios, resultado, puerta_vacia, puertas_string, ronda) do

    if ronda <= 6 do
      IO.puts("Ronda #" <> to_string(ronda))
      IO.puts(puertas_string)
      IO.puts("Seleccione la puerta: ")
      puerta_seleccionada = String.trim(IO.gets(""))
      puerta = seleccionar_puerta(puerta_seleccionada)
      if verificarPuerta?(puertas, puerta) do
        #actualizar valor correspondiente a puerta seleccionada
        puertas = Map.put(puertas, puerta, Map.get(puertas_premios, puerta))
        #contar numero de llantas
        resultado = numero_llantas(puertas_premios, puerta, resultado)
        #sumar dinero
        resultado = sumar_dinero(puertas_premios, puerta, resultado)
        puerta_vacia = puertas_vacias(puertas_premios, puerta, puerta_vacia)
        puertas_string = reemplazar_valor_puerta(puertas_string, puerta_seleccionada, Map.get(puertas_premios, puerta))
        puertas_string = corregir_string(puertas_string, puerta_seleccionada, Map.get(puertas_premios, puerta))
        cond do
          Map.get(resultado, :llantas) == 4 ->
            IO.puts("Te ganaste un carro")
            IO.puts("Total acumulado: $" <> to_string(Map.get(resultado, :dinero)))
            resultado
          puerta_vacia == 3 ->
            IO.puts("Total acumulado: $" <> to_string(Map.get(resultado, :dinero)))
            IO.puts("Llantas encontradas: " <> to_string(Map.get(resultado, :llantas)))
            resultado
          true ->
            IO.puts("Total acumulado: $" <> to_string(Map.get(resultado, :dinero)))
            IO.puts("Llantas encontradas: " <> to_string(Map.get(resultado, :llantas)))
            ronda(puertas, puertas_premios, resultado, puerta_vacia, puertas_string, ronda + 1)
        end
      else
        IO.puts("Ya seleccionaste " <> to_string(puerta))
        ronda(puertas, puertas_premios, resultado, puerta_vacia, puertas_string, ronda + 1)
      end
    else
      resultado
    end

  end

  def seleccionar_puerta(puerta) do
    case puerta do
      "P1" -> :p1
      "P2" -> :p2
      "P3" -> :p3
      "P4" -> :p4
      "P5" -> :p5
      "P6" -> :p6
      "P7" -> :p7
      "P8" -> :p8
      "P9" -> :p9
      "P10" -> :p10
      _ -> :puerta_no_existe
    end
  end

  def verificarPuerta?(puertas, puerta) do
    Map.get(puertas, puerta) == nil
  end

  def numero_llantas(puertas_premios, puerta, resultado) do
    if Map.get(puertas_premios, puerta) == 0 do
      IO.puts("Has obtenido una llanta")
      Map.put(resultado, :llantas, Map.get(resultado, :llantas) + 1)
    else
      resultado
    end
  end

  def sumar_dinero(puertas_premios, puerta, resultado) do
    cond do
      Map.get(puertas_premios, puerta) == 50 ->
        IO.puts("Has obtenido $50")
        Map.put(resultado, :dinero, Map.get(resultado, :dinero) + 50)
      Map.get(puertas_premios, puerta) == 100 ->
        IO.puts("Has obtenido $100")
        Map.put(resultado, :dinero, Map.get(resultado, :dinero) + 100)
      Map.get(puertas_premios, puerta) == 200 ->
        IO.puts("Has obtenido $200")
        Map.put(resultado, :dinero, Map.get(resultado, :dinero) + 200)
      true -> resultado
    end
  end

  def puertas_vacias(puertas_premios, puerta, puerta_vacia) do
    if Map.get(puertas_premios, puerta) == nil do
      IO.puts("Puerta vacia")
      puerta_vacia + 1
    else
      puerta_vacia
    end
  end

  def reemplazar_valor_puerta(puertas_string, puerta, valor) when valor == nil do
    String.replace(puertas_string, puerta, "X")
  end

  def reemplazar_valor_puerta(puertas_string, puerta, valor) when is_integer(valor) do
    String.replace(puertas_string, puerta, to_string(valor))
  end

  def corregir_string(puertas_string, puerta, valor) when is_integer(valor) do
    if puerta == "P1" do
      String.replace(puertas_string, to_string(valor) <> "0", "P10")
    else
      puertas_string
    end
  end

  def corregir_string(puertas_string, puerta, valor) when valor == nil do
    if puerta == "P1" do
      String.replace(puertas_string, "X0", "P10")
    else
      puertas_string
    end
  end

end
