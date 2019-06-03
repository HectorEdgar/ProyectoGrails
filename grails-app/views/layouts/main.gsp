<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>
        <g:layoutTitle default="Grails"/>
    </title>
    
    
    
    <asset:javascript src="jquery-2.2.0.min.js"/>
    <asset:javascript src="Popper.js"/>
    <asset:javascript src="bootstrap.js"/>
    <asset:javascript src="scripts.js"/>
    <asset:javascript src="application.js"/>
    <asset:javascript src="validacion.js"/>
    

    <asset:stylesheet src="application.css"/>
    <asset:stylesheet src="calendario.css"/>
    <asset:stylesheet src="footer.css"/>
    <asset:stylesheet src="table.css"/>
    <asset:stylesheet src="bootstrap.css"/>
    
    
    
    <g:layoutHead/>
</head>
<body>
    
    <nav class="navbar navbar-expand-md navbar-toggleable-md navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <g:img dir="images" file="imagen.png" width="60pd"/>
            </a>
            <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
            </button>
           
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <ul class="navbar-nav mr-auto">
                    <li class="navbar-nav">
                        <a class="nav-link" href="${createLink(uri: '/inicio/index')}">
                            Inicio<span class="sr-only">(actual)</span>
                        </a>
                    </li>
                    <sec:ifAnyGranted roles="ROLE_ADMINISTRADOR">
                        <li class="nav-item">
                            <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" 
                            data-toggle="dropdown" aria-hospopup="true" aria-expanded="false">
                                Cuenta
                            </a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="${request.getContextPath()}/cuenta/create">
                                    Agregar cuenta
                                </a>
                                
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${request.getContextPath()}/cuenta/index">
                                    Ver cuentas
                                </a>
                            </div>   
                        </li>
                        </li>
                    </sec:ifAnyGranted>

                    <sec:ifAnyGranted roles='ROLE_DIRECTIVO'>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" 
                            data-toggle="dropdown" aria-hospopup="true" aria-expanded="false">
                                Jefes de equipo
                            </a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="${request.getContextPath()}/cuenta/create">
                                    Agregar jefe de equipo
                                </a>
                                
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${request.getContextPath()}/cuenta/index">
                                    Ver Jefe de equipo
                                </a>
                            </div>   
                        </li>
                    </sec:ifAnyGranted>
                    <sec:ifAnyGranted roles='ROLE_JEFE'>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" 
                            data-toggle="dropdown" aria-hospopup="true" aria-expanded="false">
                                Trabajador
                            </a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="${request.getContextPath()}/cuenta/create">
                                    Agregar trabajador
                                </a>
                                
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${request.getContextPath()}/cuenta/index">
                                    Ver trabajador
                                </a>
                            </div>
                        </li>
                    </sec:ifAnyGranted>
                    <sec:ifAnyGranted roles='ROLE_ADMINISTRADOR,ROLE_DIRECTIVO,ROLE_JEFE'>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" 
                            data-toggle="dropdown" aria-hospopup="true" aria-expanded="false">
                                Actividad
                            </a>
                            <div class="dropdown-menu">
                                <sec:ifAnyGranted roles='ROLE_ADMINISTRADOR,ROLE_DIRECTIVO'>
                                    <a class="dropdown-item" href="${request.getContextPath()}/actividad/create">
                                        Agregar actividad
                                    </a>
                                </sec:ifAnyGranted>
                                
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${request.getContextPath()}/actividad/index">
                                    Ver actividad
                                </a>

                            </div>   
                        </li>
                    </sec:ifAnyGranted>
                    <sec:ifAnyGranted roles='ROLE_ADMINISTRADOR,ROLE_JEFE,ROLE_TRABAJADOR'>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" 
                            data-toggle="dropdown" aria-hospopup="true" aria-expanded="false">
                                SubActividad
                            </a>
                            <div class="dropdown-menu">
                                <sec:ifAnyGranted roles='ROLE_ADMINISTRADOR,ROLE_JEFE'>
                                    <a class="dropdown-item" href="${request.getContextPath()}/subActividad/create">
                                        Agregar SubActividad
                                    </a>
                                </sec:ifAnyGranted>
                                
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${request.getContextPath()}/subActividad/index">
                                    Ver SubActividad
                                </a>

                            </div>   
                        </li>
                    </sec:ifAnyGranted>
                    
                    %{--
                    <sec:ifAnyGranted roles='ROLE_ADMINISTRADOR,ROLE_DIRECTIVO'>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" 
                            data-toggle="dropdown" aria-hospopup="true" aria-expanded="false">
                                Revisión
                            </a>
                            <div class="dropdown-menu">
                                <sec:ifAnyGranted roles='ROLE_ADMINISTRADOR,ROLE_DIRECTIVO'>
                                    <a class="dropdown-item" href="${request.getContextPath()}/revisionActividad/index">
                                        Revisar Actividad
                                    </a>
                                </sec:ifAnyGranted>
                                
                                
                                
                                
                            </div>   
                        </li>
                    </sec:ifAnyGranted>
                    --}%
                    <sec:ifAnyGranted roles="ROLE_ADMINISTRADOR">
                        <li class="nav-item">
                            <a class="nav-link" href="${request.getContextPath()}/usuarios/index">Usuarios</a>
                        </li>
                    </sec:ifAnyGranted>
                                         
                </ul>
                <sec:ifNotLoggedIn>
                    <form class="form-inline my-2 my-lg-0" action="${request.getContextPath()}/login/auth">
                        <button class="btn btn-outline-success my-2 my-sm-0">
                                 Iniciar Sesión
                        </button>
                    </form>
                </sec:ifNotLoggedIn>
                <sec:ifLoggedIn>
                    <li class="nav-item form-inline my-2 my-lg-0">
                        <a class="nav-link" href="${request.getContextPath()}/#">
                            <sec:username/>
                            
                        </a>
                    </li>
                    
                    <form class="form-inline my-2 my-lg-0" action="${request.getContextPath()}/logoff">
                        <button class="btn btn-outline-success my-2 my-sm-0">
                                 Cerrar sesión
                        </button>
                    </form>
                </sec:ifLoggedIn>
            </div>
        </div>

    </nav>
<sec:ifAnyGranted roles='ROLE_ADMINISTRADOR, ROLE_DIRECTIVO, ROLE_JEFE, ROLE_TRABAJADOR'>

</sec:ifAnyGranted>
    <g:layoutBody/>
    <footer class="footer fixed-bottom">
      <div class="container text-center">
        <span class="text">Universidad La Salle Oaxaca</span>
      </div>
    </footer>
    <br>
    <br>
    <br>
    <br>
    <div id="spinner" class="spinner" style="display:none;">
        <g:message code="spinner.alt" default="Loading&hellip;"/>
    </div>
    %{--<asset:javascript src="application.js"/>--}%
</body>
</html>
