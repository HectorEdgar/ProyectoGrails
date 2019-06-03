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
        <div class="container">
            <div class="row">

                <sec:ifAnyGranted roles='ROLE_TRABAJADOR'>
                    <g:each var="subActividad" status="i" in="${subActividades}">
                        <div class="card" style="max-width: 20rem;">
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
                                    <h4 class="card-title">${subActividad.nombre}</h4>
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
                                            <th scope="row">Sub-Actividades</th>
                                            <td>
                                                <g:if test="${subActividades[i]!=0}">
                                                    <g:if test="${subActividades[i]==1}">
                                                        <g:link class="text-left" action="verSubActividades" controller="subActividad" id="${subActividad.id}">Ver sub-subActividad</g:link>
                                                    </g:if>
                                                    <g:else>
                                                        <g:link class="text-left" action="verSubActividades" controller="subActividad" id="${subActividad.id}">Ver ${subActividades[i]} sub-subActividades</g:link>
                                                    </g:else>
                                                </g:if>
                                                <g:else>
                                                No hay sub-subActividades
                                                </g:else>
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
                        </div>
                    </g:each>
                </sec:ifAnyGranted>

                <sec:ifAnyGranted roles='ROLE_JEFE,ROLE_ADMINISTRADOR,ROLE_DIRECTIVO'>
                    <g:each var="subActividad" status="i" in="${subActividades}">
                        <div class="card" style="max-width: 20rem;">
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
                                    <h4 class="card-title">${subActividad.nombre}</h4>
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

            </div>
        </div>


        <sec:ifAnyGranted roles='ROLE_TRABAJADOR'>
            <div class="table-title">
                <h1>Lista de SubActividades</h1>
            </div>
            <table class="table-fill">
                <thead>
                    <tr>
                        <th class="text-left">Id</th>
                        <th class="text-left">Nombre</th>
                        <th class="text-left">Sub-actividad</th>
                        <th class="text-left">Creador</th>
                        %{--<th class="text-left">Encargado</th>--}%
                        <th class="text-left">Fecha final</th>
                        <th class="text-left">Revisión</th>

                    </tr>
                </thead>
                <tbody class="table-hover">
                    <g:each var="subActividad" status="i" in="${subActividades}">
                        <tr>
                            <td class="text-left">
                                <g:link class="text-left" action="show" controller="subActividad" id="${subActividad.id}">${subActividad.id}</g:link>
                            </td>
                            <td class="text-left">${subActividad.nombre}</td>
                            <td class="text-left">${subActividad.actividad}</td>
                            <td class="text-left">
                                <g:link class="text-left" action="show" controller="cuenta" id="${subActividad.creador.id}">${subActividad.creador}</g:link>
                            </td>
                            %{--
                            <td class="text-left">
                                <g:link class="text-left" action="show" controller="cuenta" id="${subActividad.encargado.id}">${subActividad.encargado}</g:link>
                            </td>
                            --}%
                            <td class="text-left">${subActividad.fechaFinal}</td>
                            
                            <g:if test="${revisionSubActividades[i] == null}">
                                <g:if test="${subActividad.progreso < 100}">
                                    <td class="text-left">
                                    En proceso...
                                </g:if>
                                <g:else>
                                    <td class="text-left ">
                                    <div class="alert alert-info" role="alert">
                                        <g:link class="text-left" action="create" controller="RevisionSubActividad" id="${subActividad.id}">Enviar a revisión</g:link>
                                    </div>
                                </g:else>
                                
                                
                            </g:if>
                            <g:elseif test="${revisionSubActividades[i].isRevisado}">
                                <g:if test="${revisionSubActividades[i].isAprobado}">
                                <td class="text-left">
                                    <div class=" alert alert-success" role="alert">
                                        <strong>Aprobado</strong> 
                                        <br/>
                                        <div>
                                            ${revisionSubActividades[i].retroalimentacion}
                                        </div>
                                    </div>
                                    
                                </g:if>
                                <g:else>
                                <td class="text-left">
                                    <div class="alert alert-danger" role="alert">
                                        <strong>No aprobado</strong>
                                        <br/>
                                        <div>
                                            ${revisionSubActividades[i].retroalimentacion}
                                            <br>
                                            <g:link class="text-left" action="create" controller="RevisionSubActividad" id="${subActividad.id}">Reenviar a revisión</g:link>
                                        </div>
                                    </div>
                                    
                                </g:else>
                            </g:elseif>
                            <g:else>
                            <td class="text-left">
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
        <sec:ifAnyGranted roles='ROLE_JEFE,ROLE_ADMINISTRADOR'>
            <div class="table-title">
                <h1>Lista de SubActividades</h1>
            </div>
            <table class="table-fill">
                <thead>
                    <tr>
                        <th class="text-left">Id</th>
                        <th class="text-left">Nombre</th>
                        <th class="text-left">Sub-actividad</th>
                        <th class="text-left">Creador</th>
                        <th class="text-left">Encargado</th>
                        <th class="text-left">Fecha final</th>
                        <th class="text-left">Revisión</th>

                    </tr>
                </thead>
                <tbody class="table-hover">
                    <g:each var="subActividad" status="i" in="${subActividades}">
                        
                        <tr>
                            <td class="text-left">
                                <g:link class="text-left" action="show" controller="subActividad" id="${subActividad.id}">${subActividad.id}</g:link>
                            </td>
                            <td class="text-left">${subActividad.nombre}</td>
                            <td class="text-left">${subActividad.actividad}</td>
                            <td class="text-left">
                                <g:link class="text-left" action="show" controller="cuenta" id="${subActividad.creador.id}">${subActividad.creador}</g:link>
                            </td>
                            <td class="text-left">
                                <g:link class="text-left" action="show" controller="cuenta" id="${subActividad.encargado.id}">${subActividad.encargado}</g:link>
                            </td>
                            <td class="text-left">${subActividad.fechaFinal}</td>
                            <td class="text-left">
                            <g:if test="${revisionSubActividades[i] != null}">
                                <g:if test="${!revisionSubActividades[i].isRevisado}">
                                <div class="alert alert-info" role="alert">
                                    <strong>SubActividad terminada</strong>
                                    <br/>
                                    <g:link class="text-left" action="edit" controller="RevisionSubActividad" id="${revisionSubActividades[i].id}">
                                            Revisar SubActividad
                                    </g:link>
                                </div>
                                 </g:if>
                                 <g:else>
                                    <g:if test="${revisionSubActividades[i].isAprobado}">
                                    <div class=" alert alert-success" role="alert">
                                        <strong>Aprobado</strong> 
                                        <br/>
                                        <div>
                                            ${revisionSubActividades[i].retroalimentacion}
                                        </div>
                                    </div>
                                        
                                    </g:if>
                                    <g:else>
                                        <div class="alert alert-danger" role="alert">
                                        <strong>No aprobado</strong>
                                        <br/>
                                        <div>
                                            ${revisionSubActividades[i].retroalimentacion}
                                        </div>
                                    </div>
                                    </g:else>
                                 </g:else>
                                
                            </g:if>
                            <g:else>
                                <div class="alert alert-warning" role="alert">  
                                    <div>
                                        SubActividad en progreso
                                    </div>
                                </div>
                                
                            </g:else>
                                
                            </td>
                        </tr>
                        
                    </g:each>
                </tbody>
            </table>
        </sec:ifAnyGranted>
            <div class="pagination">
                <g:paginate total="${subActividadCount ?: 0}" />
            </div>
        </div>
    </body>
</html>