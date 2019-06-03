package mx.mrhe

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.converters.JSON
import javax.servlet.MultipartConfigElement
import javax.servlet.*
import java.io.*
import javax.servlet.http.*


@Secured(['ROLE_ADMINISTRADOR','ROLE_DIRECTIVO','ROLE_JEFE','ROLE_TRABAJADOR'])
@Transactional(readOnly = false)
class ArchivoController {

	static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

	def index(Integer max) {
		params.max = Math.min(max ?: 10, 100)
		respond Archivo.list(params), model:[archivoCount: Archivo.count()]
	}
/*
	def importarUsuarios() {
		//recuperamos el archivo en la varible archivo (fileName) es el nombre
		// del imput file del gsp
		def archivo= request.getFile()
		println archivo
		// creamos el directorio en la ruta donde esta nuestra aplicacion y agragamos la carpeta
		//cargaUsuarios ese nombre cambia para lo que ustedes necesiten
		def webRootDir = servletContext.getRealPath("/")
		def userDir = new File(webRootDir, "/cargaUsuarios")
		userDir.mkdirs()
		// se guarda el archivo en esa carpeta
		archivo.transferTo( new File( userDir, archivo.originalFilename))
		// si necesitan el apth del archivo lo pueden obtener asi
		String file=userDir.toString()+ File.separator + archivo.originalFilename
		//agregamos el nombre del archivo a una lista en caso de querer imprimir el nombre
		ArrayList nomArchivo=new ArrayList()
		nomArchivo.add(archivo.originalFilename)
		//regresamos la lista a un gsp y asi cargamos un archivo al servidor
		//render(view:'/importarDatos/importar', model:[nomArchivo:nomArchivo])
	}
	*/
	def show(Archivo archivo) {
		respond archivo
	}

	def create() {
		respond new Archivo(params)
	}

	@Transactional
	def save(Archivo archivo) {

		if (archivo == null) {
			transactionStatus.setRollbackOnly()
			notFound()
			return
		}
		println "*****"
		println params.nombre
		String nombre=params.nombre
		/*for(item in params.nombre) {
			println item
			def archivos= request.getPart(item)
		}
		*/
		def archivos = request.getParts()
		//def archivos = request.getPart("nombre")
		for(item in archivos) {
			println "--"
			//println item.size()
			//println item.getSubmittedFileName()
			String fileName = getFileName(item);
			if(fileName!="" && fileName=="nombre"){
				println fileName
				String ubicacion = request.getServletContext().getRealPath("/")+"archivosUsuarios"
				println ubicacion
				def storagePathDirectory = new File(ubicacion)

				if (!storagePathDirectory.exists()) {
					storagePathDirectory.mkdirs()
				}
				InputStream is = item.getInputStream();
				String ruta = request.getServletContext().getRealPath("/") + "archivosUsuarios" + "/" + item.getSubmittedFileName();

				FileOutputStream fos = new FileOutputStream(new File(ruta));
				int dato = is.read();
				while (dato != -1) {
					fos.write(dato);
					dato = is.read();
				}
				fos.close();
				is.close();
				File file = new File(ruta)
				Double peso=file.length()/1024
				Archivo archivoNuevo = new Archivo(
					nombre: item.getSubmittedFileName(),
					ubicacion: ruta,
					peso: peso
					)
				archivoNuevo.save flush:true
				/*
				println archivoNuevo
				println archivoNuevo.id
				println archivoNuevo.ubicacion
				println archivoNuevo.peso
				*/
			}
		}
        redirect(controller: "archivo", action: "index", params: [flash: "Se envió actividad a revisión"])




		//println archivos
		//
		/*
		println "*****"
		String ubicacion = request.getServletContext().getRealPath("/")+"archivosUsuarios"
		println ubicacion
		def storagePathDirectory = new File(ubicacion)

        if (!storagePathDirectory.exists()) {
            storagePathDirectory.mkdirs()
        }
		InputStream is = archivos.getInputStream();
		String ruta = request.getServletContext().getRealPath("/") + "archivosUsuarios" + "/" + archivos.getSubmittedFileName();
		FileOutputStream fos = new FileOutputStream(new File(ruta));
		int dato = is.read();
		while (dato != -1) {
			fos.write(dato);
			dato = is.read();
		}
		fos.close();
		is.close();
		*/

		//String ruta = request.getServletContext().getRealPath("/") + "/img" + "/" + archivo.getSubmittedFileName();
		//importarUsuarios()
		//
		/*
		if (archivo.hasErrors()) {
			transactionStatus.setRollbackOnly()
			respond archivo.errors, view:'create'
			return
		}

		//archivo.save flush:true
		/*
		request.withFormat {
			form multipartForm {
				flash.message = message(code: 'default.created.message', args: [message(code: 'archivo.label', default: 'Archivo'), archivo.id])
				redirect archivo
			}
			'*' { respond archivo, [status: CREATED] }
		}
		*/
	}

	public static String getFileName(Part part) {
		String contentDisp = part.getHeader("content-disposition");
		System.out.println("content-disposition header= " + contentDisp );
		String[] tokens = contentDisp.split(";");
		for (String token : tokens) {
			if (token.trim().startsWith("name")) {
				return token.substring(token.indexOf("=") + 2,
					token.length() - 1 );
			}
		}
		return ""
	}

	def edit(Archivo archivo) {
		respond archivo
	}

	@Transactional
	def update(Archivo archivo) {
		if (archivo == null) {
			transactionStatus.setRollbackOnly()
			notFound()
			return
		}

		if (archivo.hasErrors()) {
			transactionStatus.setRollbackOnly()
			respond archivo.errors, view:'edit'
			return
		}

		archivo.save flush:true

		request.withFormat {
			form multipartForm {
				flash.message = message(code: 'default.updated.message', args: [message(code: 'archivo.label', default: 'Archivo'), archivo.id])
				redirect archivo
			}
			'*'{ respond archivo, [status: OK] }
		}
	}

	@Transactional
	def delete(Archivo archivo) {

		if (archivo == null) {
			transactionStatus.setRollbackOnly()
			notFound()
			return
		}

		archivo.delete flush:true

		request.withFormat {
			form multipartForm {
				flash.message = message(code: 'default.deleted.message', args: [message(code: 'archivo.label', default: 'Archivo'), archivo.id])
				redirect action:"index", method:"GET"
			}
			'*'{ render status: NO_CONTENT }
		}
	}

	protected void notFound() {
		request.withFormat {
			form multipartForm {
				flash.message = message(code: 'default.not.found.message', args: [message(code: 'archivo.label', default: 'Archivo'), params.id])
				redirect action: "index", method: "GET"
			}
			'*'{ render status: NOT_FOUND }
		}
	}
}
