Code.require_file("Util2.ex", __DIR__)

defmodule Cuadrados do
  def main do
    lado = Util2.ingresar("Lado del cuadrado inicial: ", :int)
    cantidad = Util2.ingresar("Cantidad de cuadrados: ", :int)
    reduccion = Util2.ingresar("Reducción del lado en cada paso: ", :int)

    generar_svg(lado, cantidad, reduccion)
  end

  # Caso base cuando ya no faltan cuadrados por dibujar.
  def dibujar(_x, _y, _lado, faltan, _reduccion) when faltan <= 0, do: ""

  # Caso base cuando el lado ya no es positivo.
  def dibujar(_x, _y, lado, _faltan, _reduccion) when lado <= 0, do: ""

  # Recursividad
  def dibujar(x, y, lado, faltan, reduccion) do
    # El color y el grosor del borde se definen una sola vez en el grupo <g>
    # de generar_svg, así cada cuadrado solo necesita posición y tamaño.
    cuadrado =
      ~s(    <rect x="#{x}" y="#{y}" width="#{lado}" height="#{lado}"/>\n)

    # Para conservar el centro, la esquina se mueve la mitad de la reducción
    # y el lado disminuye la reducción completa.
    nuevo_x = x + reduccion / 2
    nuevo_y = y + reduccion / 2
    nuevo_lado = lado - reduccion

    cuadrado <> dibujar(nuevo_x, nuevo_y, nuevo_lado, faltan - 1, reduccion)
  end

  # Arma el archivo SVG completo y lo guarda.
  def generar_svg(lado, cantidad, reduccion) do
    margen = 10
    tamano = lado + 2 * margen

    # Tamaño fijo con el que se muestra la imagen. El viewBox escala las
    # coordenadas, así que una figura pequeña se ve ampliada.
    pantalla = 600

    # Grosor del borde: máximo 1, pero más delgado si la reducción es pequeña
    # para que las líneas no se tapen entre sí.
    grosor = max(0.1, min(1, abs(reduccion) / 5))

    contenido = dibujar(margen, margen, lado, cantidad, reduccion)

    svg =
      ~s(<svg xmlns="http://www.w3.org/2000/svg" width="#{pantalla}" height="#{pantalla}" ) <>
        ~s(viewBox="0 0 #{tamano} #{tamano}">\n) <>
        ~s(  <rect width="100%" height="100%" fill="white"/>\n) <>
        ~s(  <g fill="none" stroke="black" stroke-width="#{grosor}">\n) <>
        contenido <>
        "  </g>\n" <>
        "</svg>\n"

    File.write!("cuadrados.svg", svg)
    Util2.mostrar("Archivo cuadrados.svg generado correctamente.", :mensaje)
  end
end

Cuadrados.main()
