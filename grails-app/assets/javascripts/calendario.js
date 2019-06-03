
function obtenerFechas() {
  var fechas=[]
  var div=document.getElementById('fechas')
  var inputs=div.querySelectorAll("input")
  //alert('elementos: '+inputs.length)
  for (var i = 0; i < inputs.length; i++) {
    var values=inputs[i].value.split("-");
    var dia = values[0];
    var mes = values[1];
    var ano = values[2];
    //alert(inputs[i].getAttribute("id"))
    var fecha=[dia,mes,ano,inputs[i].getAttribute("id"),inputs[i].getAttribute("name")];
    fechas[fechas.length]=fecha
    //alert(fechas[fechas.length-1])
  }
  return fechas
}


var bandera=false;
var id=0;
var diasTotales;
var nulos;
var html;
var fecha;
var inicioMes;
var finalMes;
var ultimoDia;
var numMes;
var numAno;
var fechaActual;
var htmlYear;
function init(mes,ano) {
  // body...
  html = document.getElementById('mes');
  html.innerHTML="";
  htmlYear=document.getElementById('year');

  if(bandera){
    fecha = new Date(ano,mes+1,0);
    inicioMes = new Date(ano, mes, 1);
    finalMes = new Date(ano, mes+1, 0);
    ultimoDia = finalMes.getDate();
    numMes=mes;
    numAno=ano;
    htmlYear.innerHTML=ano
    //alert(mes)
    //alert(ano)

  }else{
    fecha = new Date();
    fechaActual=new Date();
    //alert(fecha.getFullYear())
    //alert(fecha.getMonth())
    inicioMes = new Date(fecha.getFullYear(), fecha.getMonth(), 1);
    finalMes = new Date(fecha.getFullYear(), fecha.getMonth() + 1, 0);
    ultimoDia = finalMes.getDate();
    numMes=fecha.getMonth()
    bandera=true
    numAno=fecha.getFullYear()
    htmlYear.innerHTML=fecha.getFullYear()
  }
  
  
  id = 0; //introducira el id de los div
  diasTotales = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42
  ];
  var diaSemana = inicioMes.getDay; //dia en el que empieza el primer dia del mes
  nulos = inicioMes.getDay() + 7; //cantidad de dias que no tienen que aparecer en el calendario
  var meses = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];
  
  var mesActual=document.getElementById('mesActual');
  //mesActual.setAttribute("class","text-center ");
  mesActual.innerHTML=meses[numMes];
  //mesActual.textContent = meses[numMes]; //mostramos el mes
}
//Iniciamos
init(0,0)
function crearCalendario() {
  
  for (var i = 1; i <= diasTotales.length; i++) {
    if (i < nulos) {
      html.innerHTML += '<div class="nulos"></div>';
    } else {
      if (i < ultimoDia + nulos) {
        id = id + 1;
        if (id == fechaActual.getDate() && fecha.getMonth()==fechaActual.getMonth() && fecha.getYear()==fechaActual.getYear()) {
          html.innerHTML +=
          '<div id="' +
          id +
          '" class="dia bg-secondary"><p class="blanco text-center ">' +
          id +
          "</p></div>";
        } else {
          var bandera=false
          var pos=0
          for (var j = 0; j < fechas.length; j++) {
            //alert(fecha.getFullYear())
            //alert(parseInt(fechas[j][1])+" == "+(fecha.getMonth()+1)+" : "+(parseInt(fechas[j][1])==(fecha.getMonth()+1)))
            if (parseInt(fechas[j][1])==(fecha.getMonth()+1) && parseInt(fechas[j][0])==id && parseInt(fechas[j][2])==fecha.getFullYear()) {
              //alert("entro")
              pos=j
              bandera=true
              break;
            }
          }
          if(bandera) {
            var clase=""
            switch(parseInt(fechas[pos][3])){
              case 0:
              clase="bg-info"
              break;
              case 1:
              clase="bg-primary"
              break;
              case 2:
              clase="bg-success"
              break;
              case 3:
              clase="bg-danger"
              break;
              case 4:
              clase="bg-warning"
              break;
            }
            html.innerHTML +=
            '<div onclick="pos(this.id)" id="' + id + '" class="dia '+clase+' text-white " ><p class="blanco text-center">' + id + "</p></div>";
          }else{
            html.innerHTML +=
            '<div onclick="pos(this.id)" id="' + id + '" class="dia text-center"><p class="num text-center">' + id + "</p></div>";
          }
        }
      } else {
        html.innerHTML += '<div class="nulos"></div>';
      }
    }
  }
}
function crearLeyenda() {
  var auxVista=document.getElementById('leyenda');
  
  var cont=0;
  var fechasOrdenadas=[]
  for (var j = 0; j < fechas.length; j++) {
    if (parseInt(fechas[j][1])==(fecha.getMonth()+1) && parseInt(fechas[j][2])==fecha.getFullYear()) {
      if(cont==0){
        fechasOrdenadas[fechasOrdenadas.length]=fechas[j];
      }else{
        var pivote=fechas[j];
        for (var i = 0; i <fechasOrdenadas.length; i++) {

          if(fechasOrdenadas[i][0]<pivote[0]) {
            var auxFecha=fechasOrdenadas[i];
            fechasOrdenadas[i]=pivote;
            pivote=auxFecha;
          }
          if(fechasOrdenadas.length == i+1) {
              fechasOrdenadas[i]=pivote;
              break;
          }
        }
        
      }
    }
  }
  if(fechasOrdenadas.length>0){
    auxVista.innerHTML='<h4 class="text-center">Leyenda</h4>';
  }else{
    auxVista.innerHTML="";
  }
  
  for (var j = 0; j < fechasOrdenadas.length; j++) {
      switch(parseInt(fechasOrdenadas[j][3])){
        case 0:
        clase="bg-info"
        break;
        case 1:
        clase="bg-primary"
        break;
        case 2:
        clase="bg-success"
        break;
        case 3:
        clase="bg-danger"
        break;
        case 4:
        clase="bg-warning"
        break;
      }
      auxVista.innerHTML += ''+
      '<div class="dia '+clase+' text-white " ><p class="blanco text-center">' + fechasOrdenadas[j][0] + "</p></div>"+
      fechasOrdenadas[j][4]+'<br>';
  }
  //auxVista.innerHTML +='</div>'
}
var fechas=obtenerFechas()
crearCalendario()
crearLeyenda()

function anterior() {
  numMes=numMes-1;
  if(numMes==-1){
    numMes=11;
    numAno=numAno-1
  }
  init(numMes,numAno)
  crearCalendario()
  crearLeyenda()
}
function siguiente() {
  numMes=numMes+1;
  if(numMes==12){
    numMes=0
    numAno=numAno+1
  }
  init(numMes,numAno)
  crearCalendario()
  crearLeyenda()
}

function pos(id){
  var lienzo = document.getElementById('calendario');
  var elemento = document.getElementById(id);
  var posicion = elemento.getBoundingClientRect();
  console.log(posicion.top+5, posicion.left+5);
}