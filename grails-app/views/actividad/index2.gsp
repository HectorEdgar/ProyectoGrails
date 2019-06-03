<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'actividad.label', default: 'Actividad')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <asset:stylesheet src="table.css"/>
    </head>
    <body>
        <a href="#list-actividad" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <br>
       
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
        <div class="row">
            <div class="col-12">
                <sec:ifAnyGranted roles='ROLE_JEFE'>
                    <div class="table-title">
                        <h1>Lista de actividades</h1>
                    </div>
                    <table class="table-fill">
                        <thead>
                            <tr>
                                <th class="text-left">Id</th>
                                <th class="text-left">Nombre</th>
                                <th class="text-left">Creador</th>
                                %{--<th class="text-left">Encargado</th>--}%
                                <th class="text-left">Fecha final</th>
                                <th class="text-left">Progreso</th>
                                <th class="text-left">Sub-actividades</th>
                                <th class="text-left">Revisión</th>
                            </tr>
                        </thead>
                        <tbody class="table-hover">
                            <g:each var="actividad" status="i" in="${actividades}">
                                <input type="text" hidden="hidden" value="${actividad.fechaFinal.getDate()}" name="${i}"/>
                                
                                <tr>
                                    <td class="text-center">
                                        <g:link class="text-left" action="show" controller="actividad" id="${actividad.id}">${actividad.id}</g:link>
                                    </td>
                                    <td class="text-center">${actividad.nombre}</td>
                                    <td class="text-center">
                                        <g:link class="text-left" action="show" controller="cuenta" id="${actividad.creador.id}">${actividad.creador}</g:link>
                                    </td>
                                    %{--
                                    <td class="text-left">
                                        <g:link class="text-left" action="show" controller="cuenta" id="${actividad.encargado.id}">${actividad.encargado}</g:link>
                                    </td>
                                    --}%
                                    <td class="text-center">${actividad.fechaFinal}</td>
                                    <td class="text-center">${actividad.progreso}</td>
                                    <td class="text-center">
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
                                    <g:if test="${revisionActividades[i] == null}">
                                        <g:if test="${actividad.progreso < 100}">
                                            <td class="text-center">
                                            En proceso...
                                        </g:if>
                                        <g:else>
                                            <td class="text-center ">
                                            <div class="alert alert-info" role="alert">
                                              <strong>Actividad terminada</strong>
                                              <br/>
                                                <g:link class="text-left" action="create" controller="RevisionActividad" id="${actividad.id}">Enviar a revisión</g:link>
                                            </div>
                                        </g:else>
                                        
                                        
                                    </g:if>
                                    <g:elseif test="${revisionActividades[i].isRevisado}">
                                        <g:if test="${revisionActividades[i].isAprobado}">
                                        <td class="text-center">
                                            <div class=" alert alert-success" role="alert">
                                                <strong>Aprobado</strong> 
                                                <br/>
                                                <div>
                                                    ${revisionActividades[i].retroalimentacion}
                                                </div>
                                            </div>
                                            
                                        </g:if>
                                        <g:else>
                                        <td class="text-center">
                                            <div class="alert alert-danger" role="alert">
                                                <strong>No aprobado</strong>
                                                <br/>
                                                <div>
                                                    ${revisionActividades[i].retroalimentacion}
                                                    <br>
                                                    <g:link class="text-left" action="create" controller="RevisionActividad" id="${actividad.id}">Reenviar a revisión</g:link>
                                                </div>
                                            </div>
                                            
                                        </g:else>
                                    </g:elseif>
                                    <g:else>
                                    <td class="text-center">
                                        <div class="alert alert-warning" role="alert">
                                            <strong>Enviado a revisión</strong> 
                                            <br/>
                                            <div>
                                                En espera...
                                            </div>
                                        </div>
                                        
                                    </g:else>
                                        
                                    </td>
                                </tr>

                            </g:each>
                        </tbody>
                    </table>
                </sec:ifAnyGranted>
                <sec:ifAnyGranted roles='ROLE_DIRECTIVO,ROLE_ADMINISTRADOR'>
                    <div class="table-title">
                        <h1>Lista de actividades</h1>
                    </div>
                    <table class="table-fill">
                        <thead>
                            <tr>
                                <th class="text-left">Id</th>
                                <th class="text-left">Nombre</th>
                                <th class="text-left">Creador</th>
                                <th class="text-left">Encargado</th>
                                <th class="text-left">Fecha final</th>
                                <th class="text-left">Progreso</th>
                                <th class="text-left">Revisión</th>

                            </tr>
                        </thead>
                        <tbody class="table-hover">
                            <g:each var="actividad" status="i" in="${actividades}">
                            
                                <input type="text" hidden="hidden" value="${actividad.fechaFinal.getDate()}-${actividad.fechaFinal.getMonth()}-${actividad.fechaFinal.getYear()}" name="${i}"/>
                                <tr>
                                    <td class="text-left">
                                        <g:link class="text-left" action="show" controller="actividad" id="${actividad.id}">${actividad.id}</g:link>
                                    </td>
                                    <td class="text-left">${actividad.nombre}</td>
                                    <td class="text-left">
                                        <g:link class="text-left" action="show" controller="cuenta" id="${actividad.creador.id}">${actividad.creador}</g:link>
                                    </td>
                                    <td class="text-left">
                                        <g:link class="text-left" action="show" controller="cuenta" id="${actividad.encargado.id}">${actividad.encargado}</g:link>
                                    </td>
                                    <td class="text-left">${actividad.fechaFinal}</td>
                                    <td class="text-left">${actividad.progreso}</td>
                                    <td class="text-left">
                                    <g:if test="${revisionActividades[i] != null}">
                                        <g:if test="${!revisionActividades[i].isRevisado}">
                                        <div class="alert alert-info" role="alert">
                                            <strong>Actividad terminada</strong>
                                            <br/>
                                            <g:link class="text-left" action="edit" controller="RevisionActividad" id="${revisionActividades[i].id}">
                                                    Revisar Actividad
                                            </g:link>
                                        </div>
                                         </g:if>
                                         <g:else>
                                            <g:if test="${revisionActividades[i].isAprobado}">
                                            <div class=" alert alert-success" role="alert">
                                                <strong>Aprobado</strong> 
                                                <br/>
                                                <div>
                                                    ${revisionActividades[i].retroalimentacion}
                                                </div>
                                            </div>
                                                
                                            </g:if>
                                            <g:else>
                                                <div class="alert alert-danger" role="alert">
                                                <strong>No aprobado</strong>
                                                <br/>
                                                <div>
                                                    ${revisionActividades[i].retroalimentacion}
                                                </div>
                                            </div>
                                            </g:else>
                                         </g:else>
                                        
                                    </g:if>
                                    <g:else>
                                        <div class="alert alert-warning" role="alert">  
                                            <div>
                                                Actividad en progreso
                                            </div>
                                        </div>
                                        
                                    </g:else>
                                        
                                    </td>
                                </tr>
                                
                            </g:each>
                        </tbody>
                    </table>
                </sec:ifAnyGranted>
                
           </div>
            <div id="calendario" class="col-4">
                <div id="etiquetas"class="">
                    <div class="semana" >L</div>
                    <div class="semana" >M</div>
                    <div class="semana" >X</div>
                    <div class="semana" >J</div>
                    <div class="semana" >V</div>
                    <div class="semana" >S</div>
                    <div class="semana" >D</div>
                </div>
                <div id="barraMes">
                    <p id="mesActual"></p>
                </div>
                <div id="mes" class=""></div>
            </div>
        </div>
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