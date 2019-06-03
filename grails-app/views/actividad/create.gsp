<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main" />
		<g:set var="entityName" value="${message(code: 'actividad.label', default: 'Actividad')}" />
		<title><g:message code="default.create.label" args="[entityName]" /></title>
	</head>
	<body>
		<div id="create-actividad" class="content scaffold-create" role="main">
			<br>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="${createLink(uri: '/')}">Inicio</a></li>
					<li class="breadcrumb-item"><a href="${createLink(uri: '/actividad')}">Actividad</a></li>
					<li class="breadcrumb-item active" aria-current="page">Crear</li>
				</ol>
			</nav>
			<h1><g:message code="default.create.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:if test="${mensaje!=null}">
				<div class="message" role="status">${mensaje}</div>
			</g:if>
			<g:hasErrors bean="${this.actividad}">
			<ul class="errors" role="alert">
				<g:eachError bean="${this.actividad}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<sec:ifAnyGranted roles="ROLE_ADMINISTRADOR,ROLE_DIRECTIVO">
				<div class="container">

					<div class="row">
						<div class="clearfix col-1"></div>
						<div class="col-10">
							<br>
							<g:form method="POST" enctype="multipart/form-data" action="save" controller="actividad">
								<div class="form-group">
									<label for="encargado">Encargado: </label>
									<select class="form-control" id="encargado" name="encargado" required="required">
										<g:each in="${cuentas}">
											<option value="${it.id}">${it.nombre}</option>
										</g:each>
									</select>
								</div>
								<div class="form-group">
									<label for="nombre">Nombre: </label>
									<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre de la actividad..." required="required">
								</div>
								<div class="form-group">
								    <label for="descripcion">Descripción: </label>
								    <textarea class="form-control" id="descripcion" rows="3" name="descripcion" maxlength="1000"></textarea>
								</div>

								<div class="form-group">
									<label for="fechaFinal">Fecha: </label>

									<g:datePicker name="fechaFinal"  precision="minute" value="${new Date()}" years="${(new Date().getYear()+1900)..(new Date().getYear()+1910)}" />
								</div>
								<div class="form-group">
									<label for="nombre">Archivos: </label>
									<input type="file" class="form-control" id="archivo" name="archivo">
								</div>
								<div class="row">
									<div class="clearfix col-4"></div>
								<button type="submit" class="btn btn-primary col-4">Crear</button>
								</div>


							</g:form>
						</div>
					</div>
				</div>
			%{--
				<g:form resource="${this.actividad}" method="POST" enctype="multipart/form-data">
					<fieldset class="form">
						%{-- <f:all bean="actividad"/>
						<f:with bean="actividad">
							<f:field property="encargado">
								<g:select name="encargado" from="${cuentas}"
									optionKey="id" optionValue="nombre">
								</g:select>
							</f:field>
							<f:field property="nombre"/>
							<f:field property="descripcion">
								<g:textArea name="descripcion" maxlength="1000"/>
							</f:field>
							%{--<f:field property="fechaInicio"/>
							<f:field property="fechaFinal">
								<g:datePicker name="fechaFinal"  precision="minute" value="${new Date()}" years="${(new Date().getYear()+1900)..(new Date().getYear()+1910)}" />
							</f:field>
							%{--<f:field property="progreso"/>

							<div class="fieldcontain required">
								<label for="">Archivos
									<span class="required-indicator">*</span>
								</label>
								<g:field type="file" name="archivo" width="250px" />
							</div>
						</f:with>
					</fieldset>
					<fieldset class="buttons">
						<g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
					</fieldset>
				</g:form>
				--}%
			</sec:ifAnyGranted>
			<br>
		</div>
	</body>
</html>
