<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'inicio.label', default: 'Inicio')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>

    </head>
    <body>
        <a href="#list-inicio" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>

        %{--
        <sec:ifAnyGranted roles='ROLE_ADMINISTRADOR,ROLE_DIRECTIVO,ROLE_JEFE'>
            ${redirect(controller: "actividad", action: "index")}
        </sec:ifAnyGranted>
        <sec:ifAnyGranted roles='ROLE_TRABAJADOR'>
            ${redirect(controller: "subActividad", action: "index")}
        </sec:ifAnyGranted>
--}%
        <sec:ifNotLoggedIn>
            <div class="container">
                <div class="jumbotron">
                    <h1 class="display-3 text-center">¡Bienvenido!</h1>
                    <p class="lead">Sistema de control de trabajo</p>
                    <hr class="my-4">
                    <p>Si no tienes una cuenta contacta con tu superior mas cercano</p>
                    <p class="lead">
                        <a class="btn btn-primary btn-lg" href="${request.getContextPath()}/login/auth" role="button">Iniciar Sesión</a>
                    </p>
                </div>
            </div>
        
        </sec:ifNotLoggedIn>

    </body>
</html>