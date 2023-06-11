# Planificación del Calendario de Torneos Deportivos

Esta aplicación permite generar calendarios deportivos dados unos respectivos parámetros. La idea es encontrar una solución óptima en la cual se minimice la cantidad de viajes que tenga que hacer cada equipo. La aplicación utiliza Python y Streamlit para la interfaz y para resolver las restricciones, se utiliza un modelo construido en MiniZinc.

## Requisitos previos

- Python 3.6 o superior

## Instalación

1. Clona o descarga este repositorio en tu máquina local.

2. Abre una terminal y navega hasta el directorio donde clonaste o descargaste este repositorio.

3. Crea un entorno virtual:

   ```
   python -m venv venv
   ```

4. Activa el entorno virtual:

- En macOS y Linux:
  ```
  source venv/bin/activate
  ```
- En Windows:
  ```
  venv\Scripts\activate
  ```

5. Instala las dependencias necesarias:
   ```
   pip install -r ./CalDepGUIFuentes/requirements.txt
   ```

## Uso

1. Asegúrate de tener el entorno virtual activado.

2. Ejecuta la aplicación de Streamlit:

   ```
   streamlit run ./CalDepGUIFuentes/app.py
   ```

3. Se abrirá una nueva ventana del navegador con la aplicación.

4. Haz clic en el botón "Seleccionar archivo" y selecciona un archivo de texto con el formato requerido.

- Ejemplo del formato con comentarios:
  ```python
  4 #Número de equipos
  1 #Número mínimo de permanencias y giras
  3 #Número máximo de permanencias y giras
  0 186 91 92
  186 0 95 218
  91 95 0 123
  92 218 123 0 # Matriz de distancias entre equipos
  ```

5. Por último, dar click en el botón generar solución para ver los resultados del modelo
