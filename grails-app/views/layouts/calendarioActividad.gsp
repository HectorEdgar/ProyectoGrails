<!DOCTYPE html>
<html>
<head>
	<title>
        <g:layoutTitle default="Grails"/>
    </title>
    
    <asset:stylesheet src="calendario.css"/>
</head>
<g:layoutHead/>
<body>
	
  <div id="calendario">

    <div id="etiquetas">
      <div class="semana">L</div>
      <div class="semana">M</div>
      <div class="semana">X</div>
      <div class="semana">J</div>
      <div class="semana">V</div>
      <div class="semana">S</div>
      <div class="semana">D</div>
    </div>
    <div id="barraMes">
      <p id="mesActual"></p>
    </div>
    <div id="mes"></div>
  </div>
  <asset:javascript src="calendario.js"/> 
	<g:layoutBody/>
</body>
</html>