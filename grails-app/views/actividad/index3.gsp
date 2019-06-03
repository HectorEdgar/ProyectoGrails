<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'actividad.label', default: 'Actividad')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        
    </head>
    <body>
        <a href="#list-actividad" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <br>
        <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
        </g:if>
        <g:if test="${params.flash!=null}">
            <div class="message" role="status">${params.flash}</div>
        </g:if>
        %{--
        <g:each var="revision" status="i" in="${revisionActividades}">
            ${revision}
            <br>
            hola + ${i}
        </g:each>
        --}%
        <br>

        <main role="main" class="container">
            <div class="pagination w-100" style="max-width: 63rem;">
                <g:paginate total="${actividadCount ?: 0}" class="text-center"/>
            </div>
            <br>
            <div class="row">
                <div class="invisible" id="fechas">
                    <g:each var="actividad" status="i" in="${actividades}">
                        
                        <g:if test="${revisionActividades[i] == null}">
                            <g:if test="${actividad.progreso < 100}">
                                <g:set var="estadoActividad" value="${0}"/>
                            </g:if>
                            <g:else>
                                <g:set var="estadoActividad" value="${1}"/>
                            </g:else>
                        </g:if>
                        <g:elseif test="${revisionActividades[i].isRevisado}">
                            <g:if test="${revisionActividades[i].isAprobado}">
                                <g:set var="estadoActividad" value="${2}"/>
                            </g:if>
                            <g:else>
                                <g:set var="estadoActividad" value="${3}"/>
                            </g:else>
                        </g:elseif>
                        <g:else>
                            <g:set var="estadoActividad" value="${4}"/>
                        </g:else>

                        <input type="text" id="${estadoActividad}" 
                        value="${actividad.fechaFinal.getDate()}-${actividad.fechaFinal.getMonth()+1}-${actividad.fechaFinal.getYear()+1900}" hidden="hidden" name="${actividad.nombre}">
                    </g:each>
                </div>
                <sec:ifAnyGranted roles='ROLE_JEFE'>
                    <g:each var="actividad" status="i" in="${actividades}">
                        <div class="card" style="max-width: 20rem;" hola="nada">
                          %{--<img class="card-img-top" src="..." alt="Card image cap">--}%
                            %{--<div class="card-header bg-primary text-white text-center">Actividad</div>--}%
                            <g:if test="${revisionActividades[i] == null}">
                                <g:if test="${actividad.progreso < 100}">
                                    <div class="card-header bg-info text-white text-center">Actividad en proceso...</div>
                                </g:if>
                                <g:else>
                                    <div class="card-header bg-primary text-white text-center">Actividad lista para enviar a revisión</div>
                                </g:else>
                            </g:if>
                            <g:elseif test="${revisionActividades[i].isRevisado}">
                                <g:if test="${revisionActividades[i].isAprobado}">
                                    <div class="card-header bg-success text-white text-center">Actividad aprobada</div>
                                </g:if>
                                <g:else>
                                    <div class="card-header bg-danger text-white text-center">Actividad no aprobada</div>
                                </g:else>
                            </g:elseif>
                            <g:else>
                                <div class="card-header bg-warning text-white text-center">Actividad enviada a revisión</div>
                            </g:else>

                                <div class="card-body">
                                    <h4 class="card-title">
                                        <g:link class="text-left" action="show" controller="actividad" id="${actividad.id}">${actividad.nombre}</g:link>
                                    </h4>
                                    <p class="card-text">${actividad.descripcion}</p>
                                </div>
                                <table class="table-sm table-hover">
                                    <tbody>
                                        <tr>
                                            <th scope="row">Id</th>
                                            <td class="">
                                                <g:link class="text-left" action="show" controller="actividad" id="${actividad.id}">${actividad.id}</g:link>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Creador</th>
                                            <td>
                                                <g:link class="text-left" action="show" controller="cuenta" id="${actividad.creador.id}">${actividad.creador}</g:link>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Asignado</th>
                                            <td>
                                                <g:link class="text-left" action="show" controller="cuenta" id="${actividad.encargado.id}">${actividad.encargado}</g:link>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table class="table-sm">
                                    <tbody>
                                        <tr>
                                            <th scope="row">Fecha de Inicio</th>
                                            <td>
                                                ${actividad.fechaInicio.getDate()} - 
                                                ${actividad.fechaInicio.getMonth()+1} - 
                                                ${actividad.fechaInicio.getYear()+1900} 
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Progreso</th>
                                            <td class="">${actividad.progreso}</td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Fecha de Entrega</th>
                                            <td>
                                                ${actividad.fechaFinal.getDate()} - 
                                                ${actividad.fechaFinal.getMonth()+1} - 
                                                ${actividad.fechaFinal.getYear()+1900} 
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Archivos</th>
                                            <td class="text-center">
                                                <g:if test="${actividad.archivos==null}">
                                                    No hay archivos
                                                </g:if>
                                                <g:if test="${actividad.archivos?.length==0}">
                                                    No hay archivos
                                                </g:if>
                                                <g:each var="${archivo}" in="${actividad.archivos}">
                                                    <g:link class="btn btn-sm " style="max-width:11.5rem" action="descargarArchivo" controller="actividad" params="[ubicacion: archivo.ubicacion]" data-toggle="tooltip" data-placement="top" title="${archivo}">${archivo}
                                                        %{--<g:img file="dowload.png"/>--}%
                                                    </g:link>
                                                    <br>
                                                </g:each>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Sub-Actividades</th>
                                            <td>
                                                <g:if test="${subActividades[i]!=0}">
                                                    <g:if test="${subActividades[i]==1}">
                                                        <g:link class="text-left" action="verSubActividades" controller="subActividad" id="${actividad.id}">Ver sub-actividad</g:link>
                                                    </g:if>
                                                    <g:else>
                                                        <g:link class="text-left" action="verSubActividades" controller="subActividad" id="${actividad.id}">Ver ${subActividades[i]} sub-actividades</g:link>
                                                    </g:else>
                                                </g:if>
                                                <g:else>
                                                No hay sub-actividades
                                                </g:else>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                
                                <g:if test="${revisionActividades[i] == null}">
                                    <g:if test="${actividad.progreso >= 100}">
                                        <div class="card-body text-center">
                                            <g:link class="text-left" action="create" controller="RevisionActividad" id="${actividad.id}">Enviar a revisión</g:link>
                                        </div>
                                    </g:if>
                                    <g:else>
                                        <div class="card-body text-center"></div>
                                        <div class="card-body text-center"></div>
                                    </g:else>
                                </g:if>
                                <g:elseif test="${revisionActividades[i].isRevisado}">
                                    <g:if test="${revisionActividades[i].retroalimentacion!=""}">
                                        <div class="card-body">
                                            <h5 class="card-title">Retroalimentación: </h5>
                                            <p class="card-text">${revisionActividades[i].retroalimentacion}</p>
                                        </div>
                                    </g:if>
                                    <g:else>
                                        <div class="card-body"></div>
                                    </g:else>
                                    <g:if test="${!revisionActividades[i].isAprobado}">
                                        <g:if test="${actividad.progreso >= 100}">
                                            <div class="card-body text-center">
                                                <g:link class="text-left" action="create" class="card-link" controller="RevisionActividad" id="${actividad.id}">Reenviar a revisión</g:link>
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

                <sec:ifAnyGranted roles='ROLE_DIRECTIVO,ROLE_ADMINISTRADOR'>
                    <g:each var="actividad" status="i" in="${actividades}">
                        <div class="card" style="max-width: 20rem;">
                          %{--<img class="card-img-top" src="..." alt="Card image cap">--}%
                            %{--<div class="card-header bg-primary text-white text-center">Actividad</div>--}%
                            <g:if test="${revisionActividades[i] == null}">
                                <g:if test="${actividad.progreso < 100}">
                                    <div class="card-header bg-info text-white text-center">Actividad en proceso...</div>
                                </g:if>
                                <g:else>
                                    <div class="card-header bg-primary text-white text-center">Actividad lista para enviar a revisión</div>
                                </g:else>
                            </g:if>
                            <g:elseif test="${revisionActividades[i].isRevisado}">
                                <g:if test="${revisionActividades[i].isAprobado}">
                                    <div class="card-header bg-success text-white text-center">Actividad aprobada</div>
                                </g:if>
                                <g:else>
                                    <div class="card-header bg-danger text-white text-center">Actividad no aprobada</div>
                                </g:else>
                            </g:elseif>
                            <g:else>
                                <div class="card-header bg-warning text-white text-center">Actividad enviada a revisión</div>
                            </g:else>

                                <div class="card-body">
                                    <h4 class="card-title">
                                        <g:link class="text-left" action="show" controller="actividad" id="${actividad.id}">${actividad.nombre}</g:link>
                                    </h4>
                                    <p class="card-text">${actividad.descripcion}</p>
                                </div>
                                <table class="table-sm table-hover">
                                    <tbody>
                                        <tr>
                                            <th scope="row">Id</th>
                                            <td class="">
                                                <g:link class="text-left" action="show" controller="actividad" id="${actividad.id}">${actividad.id}</g:link>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Creador</th>
                                            <td>
                                                <g:link class="text-left" action="show" controller="cuenta" id="${actividad.creador.id}">${actividad.creador}</g:link>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Asignado</th>
                                            <td>
                                                <g:link class="text-left" action="show" controller="cuenta" id="${actividad.encargado.id}">${actividad.encargado}</g:link>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table class="table-sm">
                                    <tbody>
                                        <tr>
                                            <th scope="row">Fecha de Inicio</th>
                                            <td>
                                                ${actividad.fechaInicio.getDate()} - 
                                                ${actividad.fechaInicio.getMonth()+1} - 
                                                ${actividad.fechaInicio.getYear()+1900} 
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Progreso</th>
                                            <td class="">${actividad.progreso}</td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Fecha de Entrega</th>
                                            <td>
                                                ${actividad.fechaFinal.getDate()} - 
                                                ${actividad.fechaFinal.getMonth()+1} - 
                                                ${actividad.fechaFinal.getYear()+1900} 
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Archivos</th>
                                            <td class="text-center">
                                                <g:if test="${actividad.archivos==null}">
                                                    No hay archivos
                                                </g:if>
                                                <g:if test="${actividad.archivos?.length==0}">
                                                    No hay archivos
                                                </g:if>
                                                <g:each var="${archivo}" in="${actividad.archivos}">
                                                    <g:link class="btn btn-sm " style="max-width:11.5rem" action="descargarArchivo" controller="actividad" params="[ubicacion: archivo.ubicacion]" data-toggle="tooltip" data-placement="top" title="${archivo}">${archivo}
                                                        %{--<g:img file="dowload.png"/>--}%
                                                    </g:link>
                                                    <br>
                                                </g:each>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Sub-Actividades</th>
                                            <td>
                                                <g:if test="${subActividades[i]!=0}">
                                                    <g:if test="${subActividades[i]==1}">
                                                        <g:link class="text-left" action="verSubActividades" controller="subActividad" id="${actividad.id}">Hay 1 sub-actividad</g:link>
                                                    </g:if>
                                                    <g:else>
                                                        <g:link class="text-left" action="verSubActividades" controller="subActividad" id="${actividad.id}">Ver Hay ${subActividades[i]} sub-actividades</g:link>
                                                    </g:else>
                                                </g:if>
                                                <g:else>
                                                No hay sub-actividades
                                                </g:else>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            
                                <g:if test="${revisionActividades[i] != null}">
                                    <g:if test="${!revisionActividades[i].isRevisado}">
                                        <div class="card-body"></div>
                                        <div class="card-body text-center">
                                            <g:link class="text-left" action="edit" controller="RevisionActividad" id="${revisionActividades[i].id}">Revisar Actividad</g:link>
                                        </div>
                                    </g:if>
                                    <g:else>
                                        <g:if test="${revisionActividades[i].retroalimentacion!=""}">
                                            <div class="card-body">
                                                <h5 class="card-title">Retroalimentación: </h5>
                                                <p class="card-text">${revisionActividades[i].retroalimentacion}</p>
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
            </div>
        </main>
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
            <br><br><br>
            <div id="leyenda" class="">
            </div>
        </div>
         
        <asset:javascript src="calendario.js"/>
        %{--
        <div id="list-actividad" class="content scaffold-list " role="main">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            
            
            <f:table collection="${actividades}" properties="['id','nombre','creador','encargado','fechaFinal','progreso']"/>
            
            <g:if test="${actividades.size()==0}">
            </g:if>
            <div class="pagination">
                <g:paginate total="${actividadCount ?: 0}" />
            </div>
        </div>
        --}%
    </body>
</html>