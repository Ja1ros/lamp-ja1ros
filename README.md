# LAMP Ja1ros

Entorno de desarrollo PHP con Apache, MySQL y phpMyAdmin. Incluye la página de demostración y los datos de ejemplo del [proyecto original de Jerson Martínez](https://github.com/jersonmartinez/docker-lamp), bajo la licencia [Unlicense](LICENSE).

## Primer inicio en Zorin o Ubuntu

Con Docker Engine, Docker Compose v2 y OpenSSL instalados, clona el repositorio y arranca el entorno:

```bash
git clone https://github.com/Ja1ros/lamp-ja1ros.git
cd lamp-ja1ros
sudo bash iniciar.sh
```

El script genera dos contraseñas distintas en `.env` durante el primer inicio y espera a que los servicios estén listos. MySQL crea la base `dbname` y la cuenta `dbuser` en el primer arranque. Su comprobación de salud ejecuta una consulta autenticada con esa cuenta. El proyecto usa sus propios contenedores y volumen, con puertos distintos de los del tutorial para poder ejecutar ambos proyectos a la vez.

| Servicio | Desde Zorin | Desde Windows |
|---|---|---|
| Apache | http://127.0.0.1:32868 | http://IP_DE_ZORIN:32868 |
| phpMyAdmin | http://127.0.0.1:32869 | Mediante el túnel de abajo |

Consulta la IP de Zorin con `ip -br -4 addr`. En phpMyAdmin, inicia sesión con el valor de `MYSQL_USER` y la contraseña de `MYSQL_PASSWORD` de tu `.env`. Puedes consultarlos con `nano .env`. La aplicación usa el servidor `db` y el puerto interno `3306`.

### phpMyAdmin desde Windows

Si ya tienes SSH habilitado en Zorin, ejecuta este ejemplo en PowerShell con tu usuario y la IP actual de la VM:

```powershell
ssh -N -L 127.0.0.1:32869:127.0.0.1:32869 USUARIO@IP_DE_ZORIN
```

Deja la terminal abierta y entra en http://127.0.0.1:32869 desde Windows.

## Tus archivos y datos

Coloca tus archivos PHP en `www/`. Los archivos SQL de `dump/sql/` se cargan al inicializar un volumen nuevo. Para importar a una base ya inicializada, usa **Importar** en phpMyAdmin. Revisa cualquier sentencia DROP del SQL antes de importarlo.

Para detener el proyecto y conservar los datos, usa `sudo docker compose stop`. Para volver a arrancarlo, usa `sudo bash iniciar.sh`. Después del primer inicio, cambiar las credenciales en `.env` requiere actualizar también las cuentas en MySQL. `docker compose down -v` elimina los datos del volumen.

Si algún servicio falla, revisa `sudo docker compose ps -a` y `sudo docker compose logs --tail=50 db`.

## Credenciales locales

El archivo `.env` está excluido de Git. Conserva `.env.example` como plantilla sin contraseñas.
