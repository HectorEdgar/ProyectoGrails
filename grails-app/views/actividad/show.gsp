<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'actividad.label', default: 'Actividad')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div id="show-actividad" class="content scaffold-show" role="main">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><a href="${createLink(uri: '/')}">Inicio</a></li>
              <li class="breadcrumb-item"><a href="${createLink(uri: '/actividad')}">Actividad</a></li>
              <li class="breadcrumb-item active" aria-current="page">Ver detalle</li>
            </ol>
          </nav>
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <f:display bean="actividad" />
            <g:form resource="${this.actividad}" method="DELETE">
                <fieldset class="buttons">
                    %{--<g:link class="edit" action="edit" resource="${this.actividad}"><g:message code="default.button.edit.label" default="Edit" /></g:link>--}%
                    <sec:ifAnyGranted roles='ROLE_ADMINISTRADOR,ROLE_DIRECTIVO'>
                      <input class="delete" type="submit" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
                    </sec:ifAnyGranted>
                </fieldset>
            </g:form>
        </div>
    </body>
</html>
