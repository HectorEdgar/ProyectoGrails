<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'subActividad.label', default: 'SubActividad')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <asset:stylesheet src="table.css"/>
    </head>
    <body>
        <a href="#list-subActividad" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        
        <g:if test="${params.flash!=null}">
            <div class="message" role="status">${params.flash}</div>
        </g:if>
        <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
        </g:if>
        %{--<f:table collection="${subActividadList}"/>--}%
        <br>
        <br>

        <div class="invisible" id="fechas">
            <g:each var="subActividad" status="i" in="${subActividades}">
                <g:if test="${revisionSubActividades[i] == null}">
                    <g:if test="${subActividad.progreso < 100}">
                        <g:set var="estadoActividad" value="${0}"/>
                    </g:if>
                    <g:else>
                        <g:set var="estadoActividad" value="${1}"/>
                    </g:else>
                </g:if>
                <g:elseif test="${revisionSubActividades[i].isRevisado}">
                    <g:if test="${revisionSubActividades[i].isAprobado}">
                        <g:set var="estadoActividad" value="${2}"/>
                    </g:if>
                    <g:else>
                        <g:set var="estadoActividad" value="${3}"/>
                    </g:else>
                </g:elseif>
                <g:else>
                    <g:set var="estadoActividad" value="${4}"/>
                </g:else>
                <input type="text" id="${estadoActividad}" value="${subActividad.fechaFinal.getDate()}-${subActividad.fechaFinal.getMonth()+1}-${subActividad.fechaFinal.getYear()+1900}" hidden="hidden" name="${subActividad.nombre}">
            </g:each>
        </div>

        <div class="container-fluid">
                <div class="row">
                    <nav class="col-sm-6 col-md-4 d-none d-sm-block bg-light sidebar">
                        <div id="calendario" class="border border-secondary">
                            <div class="text-center" id="barraMes" >
                                <p id="year"></p>
                            </div>
                            <div class="btn-group w-100" role="group" aria-label="Basic example">
                                <button type="button" class="btn btn-secondary w-100" onclick="anterior()">Anterior</button>
                                <button type="button" id="mesActual" class="btn btn-outline-secondary w-100">Middle</button>
                                <button type="button" class="btn btn-secondary w-100" onclick="siguiente()">Siguiente</button>
                            </div>
                            <br>
                            <br>
                            <br>
                            <div id="etiquetas"class="">
                                <div class="semana" >L</div>
                                <div class="semana" >M</div>
                                <div class="semana" >X</div>
                                <div class="semana" >J</div>
                                <div class="semana" >V</div>
                                <div class="semana" >S</div>
                                <div class="semana" >D</div>
                            </div>
                            <div id="mes" class=""></div>
                            <br>
                            <br>
                            <br>
                            <div id="leyenda" class=""></div>
                        </div>
                    </nav>
                    <main role="main" class="col-sm-6 ml-sm-auto col-md-8 pt-3">
                        <section class="row text-center placeholders" id="imprimir">
                            <div class="pagination w-100">
                                <g:paginate total="${subActividadCount ?: 0}"/>
                                <g:link onclick="imprimir('imprimir')"> 
                                    <g:img dir="images" file="imprimir.png" height="20px"/>
                                </g:link>
                            </div>

                            <sec:ifAnyGranted roles='ROLE_TRABAJADOR'>
                                <g:each var="subActividad" status="i" in="${subActividades}">
                                    <div class="card" style="max-width:25%;min-width:19.4rem;">
                                      %{--<img class="card-img-top" src="..." alt="Card image cap">--}%
                                        %{--<div class="card-header bg-primary text-white text-center">Sub-actividad</div>--}%
                                        <g:if test="${revisionSubActividades[i] == null}">
                                            <g:if test="${subActividad.progreso < 100}">
                                                <div class="card-header bg-info text-white text-center">Sub-actividad en proceso...</div>
                                            </g:if>
                                            <g:else>
                                                <div class="card-header bg-primary text-white text-center">Sub-actividad lista para enviar a revisión</div>
                                            </g:else>
                                        </g:if>
                                        <g:elseif test="${revisionSubActividades[i].isRevisado}">
                                            <g:if test="${revisionSubActividades[i].isAprobado}">
                                                <div class="card-header bg-success text-white text-center">Sub-actividad aprobada</div>
                                            </g:if>
                                            <g:else>
                                                <div class="card-header bg-danger text-white text-center">Sub-actividad no aprobada</div>
                                            </g:else>
                                        </g:elseif>
                                        <g:else>
                                            <div class="card-header bg-warning text-white text-center">Sub-actividad enviada a revisión</div>
                                        </g:else>

                                            <div class="card-body">
                                                <h4 class="card-title">
                                                    <g:link class="text-left" action="show" controller="subActividad" id="${subActividad.id}">${subActividad.nombre}</g:link>
                                                </h4>
                                                <p class="card-text">${subActividad.descripcion}</p>
                                            </div>
                                            <table class="table-sm table-hover">
                                                <tbody>
                                                    <tr>
                                                        <th scope="row">Id</th>
                                                            <td class="">
                                                                <g:link class="text-left" action="show" controller="subActividad" id="${subActividad.id}">${subActividad.id}</g:link>
                                                            </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Actividad</th>
                                                            <td class="">
                                                                <g:link class="text-left" action="show" controller="actividad" id="${subActividad.actividad.id}">${subActividad.actividad.nombre}</g:link>
                                                            </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Creador</th>
                                                        <td>
                                                            <g:link class="text-left" action="show" controller="cuenta" id="${subActividad.creador.id}">${subActividad.creador}</g:link>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Asignado</th>
                                                        <td>
                                                            <g:link class="text-left" action="show" controller="cuenta" id="${subActividad.encargado.id}">${subActividad.encargado}</g:link>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <table class="table-sm">
                                                <tbody>
                                                    <tr>
                                                        <th scope="row">Fecha de Inicio</th>
                                                        <td>
                                                            ${subActividad.fechaInicio.getDate()} - 
                                                            ${subActividad.fechaInicio.getMonth()+1} - 
                                                            ${subActividad.fechaInicio.getYear()+1900} 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Progreso</th>
                                                        <td class="">${subActividad.progreso}</td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Fecha de Entrega</th>
                                                        <td>
                                                            ${subActividad.fechaFinal.getDate()} - 
                                                            ${subActividad.fechaFinal.getMonth()+1} - 
                                                            ${subActividad.fechaFinal.getYear()+1900} 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Archivos</th>
                                                        <td class="">
                                                            <g:if test="${subActividad.archivos==null}">
                                                                No hay archivos
                                                            </g:if>
                                                            <g:each var="${archivo}" in="${subActividad.archivos}">
                                                                <g:link class="btn btn-outline-dark btn-sm container-fluid" action="descargarArchivo" controller="subActividad" params="[ubicacion: archivo.ubicacion]" style="max-width: 11rem;">${archivo}</g:link>
                                                                
                                                            </g:each>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            
                                            <g:if test="${revisionSubActividades[i] == null}">
                                                <g:if test="${subActividad.progreso >= 100}">
                                                    <div class="card-body text-center">
                                                        <g:link class="text-left" action="create" controller="RevisionSubActividad" id="${subActividad.id}">Enviar a revisión</g:link>
                                                    </div>
                                                </g:if>
                                                <g:else>
                                                    <div class="card-body text-center"></div>
                                                    <div class="card-body text-center"></div>
                                                </g:else>
                                            </g:if>
                                            <g:elseif test="${revisionSubActividades[i].isRevisado}">
                                                <g:if test="${revisionSubActividades[i].retroalimentacion!=""}">
                                                    <div class="card-body">
                                                        <h5 class="card-title">Retroalimentación: </h5>
                                                        <p class="card-text">${revisionSubActividades[i].retroalimentacion}</p>
                                                    </div>
                                                </g:if>
                                                <g:else>
                                                    <div class="card-body"></div>
                                                </g:else>
                                                <g:if test="${!revisionSubActividades[i].isAprobado}">
                                                    <g:if test="${subActividad.progreso >= 100}">
                                                        <div class="card-body text-center">
                                                            <g:link class="text-left" action="create" class="card-link" controller="RevisionSubActividad" id="${subActividad.id}">Reenviar a revisión</g:link>
                                                        </div>
                                                    </g:if>
                                                    <g:else>
                                                    <div class="card-body"></div>
                                                </g:else>
                                                    
                                                </g:if>
                                                <g:else>
                                                    <div class="card-body"></div>
                                                </g:else>
                                            </g:elseif>
                                            <g:else>
                                                <div class="card-body"></div>
                                                <div class="card-body"></div>
                                            </g:else>
                                    </div>
                                </g:each>
                            </sec:ifAnyGranted>

                            <sec:ifAnyGranted roles='ROLE_JEFE,ROLE_ADMINISTRADOR,ROLE_DIRECTIVO'>
                                <g:each var="subActividad" status="i" in="${subActividades}">
                                    <div class="card" style="max-width:25%;min-width:19.4rem;">
                                      %{--<img class="card-img-top" src="..." alt="Card image cap">--}%
                                        %{--<div class="card-header bg-primary text-white text-center">Sub-actividad</div>--}%
                                        <g:if test="${revisionSubActividades[i] == null}">
                                            <g:if test="${subActividad.progreso < 100}">
                                                <div class="card-header bg-info text-white text-center">Sub-actividad en proceso...</div>
                                            </g:if>
                                            <g:else>
                                                <div class="card-header bg-primary text-white text-center">Sub-actividad lista para enviar a revisión</div>
                                            </g:else>
                                        </g:if>
                                        <g:elseif test="${revisionSubActividades[i].isRevisado}">
                                            <g:if test="${revisionSubActividades[i].isAprobado}">
                                                <div class="card-header bg-success text-white text-center">Sub-actividad aprobada</div>
                                            </g:if>
                                            <g:else>
                                                <div class="card-header bg-danger text-white text-center">Sub-actividad no aprobada</div>
                                            </g:else>
                                        </g:elseif>
                                        <g:else>
                                            <div class="card-header bg-warning text-white text-center">Sub-actividad enviada a revisión</div>
                                        </g:else>

                                            <div class="card-body">
                                                <h4 class="card-title">
                                                    <g:link class="text-left" action="show" controller="subActividad" id="${subActividad.id}">${subActividad.nombre}</g:link>
                                                </h4>
                                                <p class="card-text">${subActividad.descripcion}</p>
                                            </div>
                                            <table class="table-sm table-hover">
                                                <tbody>
                                                    <tr>
                                                        <th scope="row">Id</th>
                                                        <td class="">
                                                            <g:link class="text-left" action="show" controller="subActividad" id="${subActividad.id}">${subActividad.id}</g:link>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Actividad</th>
                                                        <td class="">
                                                            <g:link class="text-left" action="show" controller="actividad" id="${subActividad.actividad.id}">${subActividad.actividad.nombre}</g:link>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Creador</th>
                                                        <td>
                                                            <g:link class="text-left" action="show" controller="cuenta" id="${subActividad.creador.id}">${subActividad.creador}</g:link>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Asignado</th>
                                                        <td>
                                                            <g:link class="text-left" action="show" controller="cuenta" id="${subActividad.encargado.id}">${subActividad.encargado}</g:link>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <table class="table-sm">
                                                <tbody>
                                                    <tr>
                                                        <th scope="row">Fecha de Inicio</th>
                                                        <td>
                                                            ${subActividad.fechaInicio.getDate()} - 
                                                            ${subActividad.fechaInicio.getMonth()+1} - 
                                                            ${subActividad.fechaInicio.getYear()+1900} 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Progreso</th>
                                                        <td class="">${subActividad.progreso}</td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Fecha de Entrega</th>
                                                        <td>
                                                            ${subActividad.fechaFinal.getDate()} - 
                                                            ${subActividad.fechaFinal.getMonth()+1} - 
                                                            ${subActividad.fechaFinal.getYear()+1900} 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row">Archivos</th>
                                                        <td class="">
                                                            <g:if test="${subActividad.archivos==null}">
                                                                No hay archivos
                                                            </g:if>
                                                            <g:each var="${archivo}" in="${subActividad.archivos}">
                                                                <g:link class="btn btn-outline-dark btn-sm container-fluid" action="descargarArchivo" controller="subActividad" params="[ubicacion: archivo.ubicacion]" style="max-width: 11rem;">${archivo}</g:link>
                                                                
                                                            </g:each>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        
                                            <g:if test="${revisionSubActividades[i] != null}">
                                                <g:if test="${!revisionSubActividades[i].isRevisado}">
                                                    <div class="card-body"></div>
                                                    <div class="card-body text-center">
                                                        <g:link class="text-left" action="edit" controller="RevisionSubActividad" id="${revisionSubActividades[i].id}">Revisar Sub-actividad</g:link>
                                                    </div>
                                                </g:if>
                                                <g:else>
                                                    <g:if test="${revisionSubActividades[i].retroalimentacion!=""}">
                                                        <div class="card-body">
                                                            <h5 class="card-title">Retroalimentación: </h5>
                                                            <p class="card-text">${revisionSubActividades[i].retroalimentacion}</p>
                                                        </div>
                                                        <div class="card-body"></div>
                                                    </g:if>
                                                    <g:else>
                                                        <div class="card-body"></div>
                                                    </g:else>
                                                </g:else>
                                            </g:if>
                                            <g:else>
                                                <div class="card-body"></div>
                                                <div class="card-body"></div>
                                            </g:else>
                                    </div>
                                </g:each>
                            </sec:ifAnyGranted>

                        </section>
                    </main>
                </div>
        </div>
        <asset:javascript src="calendario.js"/>


    </body>
</html>