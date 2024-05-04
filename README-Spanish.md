<center><h1><font size="20px">Space Battle</font></h1></center>

# Integrantes

### Yonatan José Guerra Pérez
### Abdel Fregel Hernández
### José Miguel Pérez Pérez

<font size="3px">

**`Space Battle`** es una simulación interactiva donde se modela el enfrentamiento entre dos equipos en un espacio determinado para lograr un objetivo, vencer al otro equipo.

En la simulación participan dos equipos conformados por un comandante y un conjunto de subordinados a su disposición, además, cada integrante de cada equipo esta equipado con la capacidad de destruir integrantes del equipo contrario. Cada equipo tiene por objetivo capturar la bandera del equipo contrario. La simulación llega a su fin en el momento en el que uno de los dos equipos capture la bandera del otro o uno de los dos comandantes sea destruido.

## Escenario

La simulación se desarrolla en el cosmos, en un espacio de dimensiones finitas y repleto de obstáculos distribuidos de forma aleatoria por todo el espacio definido. Los equipos están formados por naves que pueden lanzar proyectiles y cada una tiene asociados unos puntos de vida y una cantidad de daño por disparo. Al comienzo los equipos se encuentran en extremos opuestos del mapa, al igual que las banderas insignias de cada equipo.

> ## Entidades involucradas

 - `Comandantes`
 - `Subordinados`
 - `Obstáculos`
 - `Proyectiles`
 - `Banderas`

> ## Relaciones definidas

 - `Comandante-Subordinado`: El comandante le da un conjunto de instrucciones a sus subordinados y estos le informan a su comandante lo que perciben a la vez que ejecutan las instrucciones recibidas de este.
 - `Naves(comandante/subordinado)-Proyectil`: Cada integrante de equipo puede disparar una vez cada cierto tiempo, cada proyectil es instanciado por alguna nave y si una nave es alcanzada por un proyectil, disminuye sus puntos de vida.
 - `Naves(comandante/subordinado)-Bandera`: Cada nave puede capturar la bandera enemiga.
 - `Obstáculo-Proyectil`: Si un proyectil impacta con un obstáculo, este es destruido.
 - `Naves(comandante/subordinado)-Obstáculo`: Ninguna nave puede pasar por un punto en donde se encuentre un obstáculo.
 - `Nave-Nave`: Las naves pueden destruirse mutuamente.

> ## Procesos involucrados

 - `Búsqueda de la bandera`: En todo momento el comandante escucha lo que le informan sus subordinados para con esa información econtrar la bandera o destruir al comandante enemigo.
 - `Ejecución de instrucciones`: En todo momento los subordinados realizan acciones independientes tales como defender o atacar hasta que les asigne un conjunto de instrucciones a ejecutar.

## Detalles

Los equipos siempre comienzan en el extremo correspondiente a su bandera insignia. Cada comandante tiene un grado de visión determinado, al igual que sus subordinados. El mapa del ambiente se genera por cuadrantes. Cada integrante de cada equipo tiene un tiempo de espera después de cada disparo. Las naves subordinadas se comportan de dos formas distintas; ejecutan las órdenes recibidas de su comandante y en caso de no tener ninguna, actúan de forma autónoma según lo más conveniente para ellas. La nave comandante es capaz de ver todo lo que sus subordinados ven.

## Interacción con el sistema

La forma de interacción con el sistema es a través de una nave **especial** asignada al usuario para que este interactúe con la simulación. Esta nave es capaz de comunicarse con el sistema y preguntar cuál es el mejor curso de acción a seguir para obtener la victoria de su equipo. Esta consulta se hace en lenguaje natural y recibe una respuesta de hacia donde debe ir y si debe defender o atacar o defender la posición. En caso de que no deba moverse, se especificará si debe atacar o defender. La respuesta tendrá el formato siguiente:

    Ve a la posición indicada

    Ataca/Defiende

### Medio

 - `Controles del usuario`: a través de estos el usuario modifica el ambiente en el que se desarrolla la simulación.
 - `Pantalla`: es donde el usuario puede observar el desarrollo de la simulación.

## Variables de interés

A partir de las descripciones anteriores podemos reconocer las siguientes variables de interés:

 - `$m,n$`: dimensiones de los cuadrantes
 - `$f$`: función de distribución usada para generar los obstáculos
 - `$r$`: rango de visión de las naves
 - `$t$`: tiempo entre cada disparo por nave
 - `$R$`: alcance de los proyectiles
 - `$L_i$`: puntos de vida por cada nave
 - `$D_i$`: cantidad de daño por disparo que inflige cada nave
 - `La posibilidad o no del fuego amigo`
 - `La posibilidad o no de la colisión entre las naves`

## Objetivo

Evaluar el comportamiento y desempeño de los comandantes a la hora de dar las instrucciones a sus subordinados observando el nivel de efectividad y correctitud de las instrucciones dadas, a la vez que se juzga las acciones independientes de los subordinados atendiendo a como impactan en el resultado final del enfrentamiento. Se prestará atención también a como reacciona el conjunto en base a las acciones tomadas por el usuario.

<center><h1><font size="20px">Detalles de implemetación</font></h1></center>

## Tecnologías usadas

> ## Godot 3.5

Es un motor de desarrollo de videojuegos de código abierto y gratuito que permite a el desarrollo juegos 2D y 3D. Fue lanzado en 2014 y se ha vuelto ampliamente conocido por su enfoque en la facilidad de uso, la flexibilidad y la eficiencia, lo que lo hace accesible tanto para principiantes como para desarrolladores experimentados. El motor de Godot ofrece una amplia gama de características, incluyendo:

 - `Editor de Escenas`: Permite a los desarrolladores construir juegos visualmente, arrastrando y soltando objetos en un espacio 2D o 3D.
 - `Sistema de Nodos`: Utiliza un sistema de nodos para organizar el código y los recursos, facilitando la reutilización y la modularidad.
 - `Scripting`: Soporta GDScript, un lenguaje de scripting propio que es similar a Python, así como C# y C++.
 - `Renderizado`: Ofrece soporte para renderizado 2D y 3D, incluyendo soporte para VR/AR.
 - `Motor de Física`: Incluye un motor de física integrado que soporta tanto física 2D como 3D.
 - `Soporte para Múltiples Plataformas`: Permite exportar juegos a una amplia gama de plataformas, incluyendo Windows, macOS, Linux, iOS, Android, y más.

> ## Python

Es un lenguaje de programación de alto nivel, interpretado y de propósito general creado en 1991. Es muy conocido por su sintáxis clara y legible, lo que lo hace fácil de aprender y usar, especialmente para principiantes. Además, es un lenguaje muy versátil que se utiliza en una amplia gama de aplicaciones, desde desarrollo web hasta ciencia de datos, inteligencia artificial, aprendizaje automático, automatización y más. Python es un lenguaje de programación dinámico, lo que significa que los tipos de datos se determinan en tiempo de ejecución. Esto permite a los programadores escribir código más flexible y menos propenso a errores. Python también es un lenguaje de programación de tipado fuerte, lo que significa que los tipos de datos de las variables deben ser declarados explícitamente. Una de las características más destacadas de Python es su amplio soporte para bibliotecas y frameworks, lo que facilita la implementación de una amplia gama de funcionalidades. Algunas de las bibliotecas más populares incluyen NumPy y Pandas para ciencia de datos, Django y Flask para desarrollo web, y TensorFlow y PyTorch para aprendizaje automático y inteligencia artificial.

> ## Gemini (LLM)

Es un modelo de lenguaje multimodal de gran capacidad desarrollado por Google DeepMind, anunciado el 6 de diciembre de 2023 como sucesor de LaMDA y PaLM. Este modelo se compone de tres variantes: Gemini Nano, Gemini Pro y Gemini Ultra, y se posiciona como competidor de GPT-4 de OpenAI. Gemini es capaz de procesar diferentes tipos de entrada, incluyendo texto, imágenes, audio y video, lo que lo hace multimodal. Se basa en transformadores que solo decodifican, optimizados para funcionar eficientemente en unidades de procesamiento tensorial (TPUs). Puede manejar hasta 32.768 tokens de contexto utilizando una técnica llamada atención multi-consulta. Además, se entrena con un conjunto de datos multimodal y multilingüe, incluyendo documentos web, libros, código, imágenes, audio y video. Desde su lanzamiento, Gemini ha demostrado superar a varios modelos de lenguaje en pruebas de referencia de la industria, incluyendo GPT-4, Claude 2 de Anthropic, Inflection-2 de Inflection AI, LLaMA 2 de Meta y Grok 1 de xAI. La versión más potente, Gemini Ultra, superó a los expertos humanos en la prueba de Comprensión de Lenguaje Multitarea Masiva (MMLU) de 57 temas, obteniendo una puntuación del 90%.

## Arquitectura de la simulación

La simulación se encuentra dividido en 3 componentes principales; un componente central **(Simulador)**, que comprende toda lo relacionado a la simulación, incluyendo el medio de comunicación con esta, y dos componentes auxiliares, uno encargado de resolver los problemas de búsqueda de caminos **(Buscador)** y otro encargado de la interpretación de lenguaje natural **(Instructor)**. Estas componentes se conectan a través de un servidor TCP para la comunicación entre ellas y el intercambio de los datos necesarios para los cómputos a realizar.

> ## Simulador

Es donde se realiza el proceso de **simulación**. Esta construida usando Godot para aprovechar el motor de físicas que posee, su facilidad a la hora de montar escenas visuales de manera acelerada y organizada, al mismo tiempo que permite la escritura de código sencilla. Todo este conjunto de posibilidades hace que Godot sea una excelente opción para crear simulaciones.

> ## Buscador

Es el encargado de computar los caminos hacia las posiciones especificadas de manera que sean los más óptimos según varios criterios predefinidos. Estos criterios pueden ser la menor distancia, menor cantidad de enemigos, mayor cantidad de escondites, etc. Está escrito en Python 3 para aprovechar las facilidades que ofrece este lenguaje en cuanto a programación de algoritmos de inteligencia artificial, gracias a la amplia gama de librerías dedicadas a este campo que se han escrito en este lenguaje. En este caso usamos la librería **NetworkX**.

### NetworkX

Es una biblioteca de Python para la creación, manipulación y estudio de la estructura, dinámica y funciones de redes complejas. Fue diseñada para trabajar con redes de cualquier tipo, incluyendo redes sociales, redes de internet, redes de transporte, redes de colaboración, entre otras. NetworkX proporciona una amplia gama de funcionalidades para analizar y visualizar redes, lo que la hace una herramienta valiosa para investigadores y profesionales en campos como la física, la biología, la sociología, la economía, entre otros.

La biblioteca NetworkX ofrece varias características clave, incluyendo:

- Creación de Redes: Permite la creación de redes desde cero o a partir de datos existentes. NetworkX soporta redes dirigidas y no dirigidas, así como redes ponderadas y no ponderadas.
- Manipulación de Redes: Proporciona funciones para agregar o eliminar nodos y aristas, cambiar atributos de nodos y aristas, y realizar otras operaciones de manipulación de redes.
- Análisis de Redes: Incluye una amplia gama de algoritmos para analizar propiedades de redes, como el grado de los nodos, la densidad de la red, la centralidad, la comunidad, entre otros.
-Visualización de Redes: Ofrece herramientas para visualizar redes de manera gráfica, lo que facilita la comprensión de la estructura y las propiedades de las redes.

Todas estas características en conjunto hacen que esta librería sea una excelente opción para la solución de problemas de búsqueda de caminos.

> ## Instructor

Es el encargado de responder la consulta en lenguaje natural hecha por el usuario. Para esto usamos **Gemini**. Este recibe una consulta con la descripción de la simulación, los objetivos y la situación actual del usuario junto con las posiciones de los enemigos que el comandante de su equipo conoce. La respuesta es una posición a la que dirigirse en caso de que deba hacerlo y si debe atacar o defender.

# Detalles específicos

Para correr la simulación primero se debe levantar el servidor con el siguiente comando:

    python main.py 127.0.0.1 8000

> ## Simulador

Es en esta componente donde se simula la situación descrita, y por lo tanto, donde se programó todo lo referente a ella.

### Aclaraciones  sobre el sistema modelado

 - `Dinámico no-estacionario`: las posiciones de las entidades cambian con el paso del tiempo.
 - `Abierto`: reacciona a las interacciones con el usuario a través de la nave asignada a este.
 - `Con Incertidumbre`: se puede saber cierta cantidad de información, como la cantidad de enemigos distintos avistados y la posible ubicación de la bandera enemiga, pero no podemos conocer la posición exacta de la bandera hasta que sea encontrada o la cantidad exacta de enemigos existentes o la zona donde estos se encuentran.

### Características del ambiente simulado

 - `Poco accesible`: los agentes no tienen información completa sobre el estado del medio.
 - `No episódico`: el comportamiento de los agentes no depende de una cantidad de episodios discretos.
 - `Estático`: el estado no se altera a no ser que los agentes lo hagan.
 - `Discreto`: existe un número fijo y finito de percepciones y acciones que lo pueden modificar.

### Agentes

Los agentes presentes en la simulación son agentes inteligentes dado que presentan un comportamiento **reactivo**,**pro-activo** y **sociable**.

 - `reactivo`: son capaces de reaccionar a los cambios que detectan a su alrededor(si una nave detecta a un enemigo, esta comienza a dispararle)
 - `pro-activo`: son capaces de tomar iniciativa para lograr sus objetivos(una nave puede detecta varios enemigos, puede decidir a cual de ellos disparar; si se le ha asignado un objetivo a destruir, es capaz de seleccionar su propio camino para perseguirlo)
 - `sociable`: intercambian información con otros agentes(cada nave le comunica al comandante lo que ve y este en decide que instrucciones dar a cada nave permitiendo así la cooperación entre ellas)

### Arquitectura de los agentes

Los agentes implementados siguen una estructura similar a una máquina de estados finitos donde cada estado representa una situación, cada estado depende únicamente de la situación del ambiente alrededor del agente, y según esta es el conjunto de acciones a realizar. Cada conjunto de acciones es extremadamente sencillo y dependen únicamente del estado del agente. A partir de estas acciones básicas, un agente es capaz de realizar acciones más complejas creando combinaciones de estas. Dada esta descripción de los agentes, podemos concluir que tienen una arquitectura de Brooks. Esta forma de construir agentes es sencilla y dado que la tarea a realizar se puede traducir a secuencias simples de acciones, se pueden generar comportamientos inteligentes de esta forma. 

### Comportamiento de los agentes 

En este caso podemos reconocer fácilmente dos tipos de agentes, el comandante y el subordinado. El comandante ordena a sus subordinados a desplazarse por el mapa mientras ejecutan ciertas acciones; a su vez, estos le informan constantemente al comandante sobre su situación(enemigos avistados y la posición de la bandera en caso de encontrarla). El comandante ordena constantemente buscar la bandera enemiga y una vez encontrada, todos los agentes convergen a la posición de la bandera.

#### Comandante
El comandante tiene una algoritmo de búsqueda que dada la visión que tiene el comandante el divide el mapa en cuadrantes del tamaño de su area de visión y por cada cuadrante elige un punto aleatorio que pertenezca a cada cuadrante y visita dicho punto una vez visitado, lo marca como visitado y escoge otro, asi nos aseguramos que visita el mapa completo. El comandante va recibiendo que es lo que ven sus aliados y va tomando ordenes en consecuencia, o sea que cuando una de las naves o el mismo detecta la bandera enemiga, da la orden de reunirse en ese punto para poder capturarla. 

> ## Buscador 

En el buscador implementamos la idea de llevar el mapa a un grafo para poder utilizar algoritmos estudiados. Con este grafo vamos descubriendo la posición de los enemigos y tambien sabemos la posición de nuestros aliados. Utilizamos la distancia Manhattan para poder ver la distancia a nuestras tropas aliadas para no alejarnos tanto de ellas y la inversa de esta función para alejarnos de los enemigos, siempre tratando de acercarnos a la bandera. En el momento que detecta dónde esta la bandera se dirige hasta donde se encuentra dicha bandera. 

### Generación de mapas 

La generación de mapas se realizó utilizando una función de distribución basada en el tick del reloj para decidir si una casilla es o no un obstáculo, la función tiene como parametro un offset y un seed que son utilizados para computar el resultado. Para el posicionamiento de la bandera escoge una mitad del mapa para ponerla, esa mitad la divide en tres secciones y de estas determina cuál tiene menor cantidad de obstáculos y en esa pone la bandera en un punto aleatorio.

> ## Experimentación

En la experimentación con la generación de mapas observamos que pasandole como parametro un offset de 2 o mayor era muy probable que el mapa fuera invalido y lo contrario utilizando un offset de 0 o 1. Tambien apreciamos que dado que los mapas se generan por cuadrantes cuyo tamaño tenemos accesos apreciamos q a menor tamaño de los cuadrantes es mas facil apreciar los patrones de obstaculos en el mapa, no siendo asi dandole un mayor tamaño a los cuadrantes en la generacion del mapa. Dada la forma en que se colocan las banderas observamos que muchas veces las banderas se enceuntran rodeadas de obstaculos lo que vimos como buena idea pues hace que sea mas dificil de acceder a ella. 

### Búsqueda de los agentes

Dado el algoritmo de búsqueda del comandante, observamos que el tiempo que demora en encontrar la bandera es de alrededor de 5 minutos, aunque este tiempo puede ser menor dado la aleatoreidad de los puntos que este escoge, y como sabemos que visita todo el mapa podemos asegurar su convergencia. Ademas sabemos que las naves aliadas una vez vista la bandera avisan al comandante para que de la orden de reunirse en ese punto lo que hace que el tiempo sea menor. Las naves priorizan atacar la bandera una vez descubierta.

### Análisis estadístico
Para el analisis estadistico tuvimos en cuenta varias metricas:
- Distancia de la bandera a los muros que la rodean(Calidad de la posicion de la bandera)
- Cantidad de naves destruidas
- Partidas ganadas
- Tiempo de la simulacion
- Cantidad de veces del comandante enemigo destruido
- Aliados que sobreviven

Se ralizaron aproximadamente 200 - 250 simulaciones con la siguiente distribución:

- 60-80 para la generación de mapas
- 40-60 para observar la ubicación de las banderas
- 60 para evaluar el comportamiento de los agentes
- 50 para evaluar la simulación completa.

Los resultados observados fueron:

1 - Para un valor de offset de 0 o 1, los mapas generados fueron válidos(no existían casillas inaccesibles) en la gran mayoría de los casos, ya que solo en 3 de las simulaciones realizadas se observaron alrededor de 7 casillas inaccesibles, mientras que con valores superiores, el número de ocurrencias de esto aumentó considerablemente(se observó este hecho en 2 de cada 5 mapas generados). Para valores distintos seleccionados del seed_, solo se observó un cambio en la forma en que se encontraban distribuidos los obstáculos presentaba mayores irregularidades, haciendo más difícil detectar patrones. Aumentar las dimensiones de los cuadrantes para generar el mapa influye de igual forma que variar el seed_.

2 - Las simulaciones realizadas en mapas pequeños solían acabar en menos de 5 minutos casi siempre por parte del equipo contrario, siempre y cuando el usuario no afectara mucho el desarrollo, la causa siempre era la captura de la bandera. En cambio, para mapas de mucha mayor dimensionalidad, la causa variabe entre captura de la bandera y destrucción de la nave comandante. Las simulaciones tardaban alrededor de 30 minutos y hasta más, siendo difícil incluso para el usuario la detección de la bandera enemiga. El número de enfrentamientos frontales disminuyó considerablemente, pero el número de naves restantes al terminar la partida no aumentó de manera proporcional.

3 - El rango de visión de las naves resultó ser una variable de gran peso en el tiempo en que demoraba la simulación en terminar.

## Limitaciones del Proyecto

-Al usar un motor de graficos vimos limitaciones a la hora de trabajar con el espacio continuo y apreciamos que tiene errores de medicion.
- No es lo suficientemente realista en cuanto al movimiento de las naves
- Al usar un servidor se ve afectado por la latencia de este aunque permite que el sistema sea distribuido 
- En las colisiones no se detectan multiples colisiones simultaneas
- Se hace dificil hacer debug
- Para mapas muy grandes se hace más notable la latencia del servidor
- Aumentar la cantidad de agentes en la simulación afecta enormemente la velocidad de esta.

> ## Conclusiones

Con este proyecto pudimos evaluar el rendimento de ciertas técnicas y algoritmos conocidos en los ámbitos de la simulación y la Inteligencia Artificial. Apreciamos las deficiencias de la arquitectura de brooks para los agentes, ya que es complicado definir conductas complejas en base a situaciones que se le presentan ya que no existe ningún tipo de inferencia por parte del agente, sino que se comporta de forma predefinida. Como ventajas de esta arquitectura se tiene la facilidad a la hora de construirlos, además de que con un gran número de estos agentes, se pueden lograr comportamientos inteligentes de forma grupal, que es lo que se buscaba en este proyecto. También podemos destacar la eficiencia del algoritmo Astar a la hora de encontrar caminos óptimos según la situación actual, haciendo énfasis a la facilidad de traducir dicha situación ya que esto se reducía a cambiar la función de costo de las aristas.


### Recomendaciones 
- Seguir investigando en la Inteligencia Artificial para mejorar las heurísticas de las naves y asi aumentar la dificultad
- Experimentar con otras variables y reglas de la simulacion para asi identificar nuevas formas de jugar
- Seguir investigando sobre Godot para darle un mejor realismo a la simulacion
- considerar otra estructura de agentes
- considerar el uso de hilos por parte del servidor y la simulación para manejar las consultas
- investigar sobre funciones para generar mapas aleatorios
