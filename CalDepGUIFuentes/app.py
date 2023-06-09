import streamlit as st
from minizinc import Instance, Model, Solver
import os


# Entra un archivo .txt y lo formatea para que sea un archivo .dzn
def format_data(input_file):
    lines = input_file.readlines()
    n = int(lines[0].strip())
    min_value = int(lines[1].strip())
    max_value = int(lines[2].strip())
    matrix = [[int(val) for val in line.split()] for line in lines[3:]]
    matrix_str = "\n|".join([", ".join(map(str, row)) for row in matrix])
    formatted_content = (
        f"n={n};\nMin={min_value};\nMax={max_value};\nD=[|{matrix_str}|];"
    )
    return formatted_content


# Aplicación
def main():
    st.title("Programación de Calendarios Deportivos")
    st.subheader(
        "Proyecto II - Análisis y Diseño de Algoritmos II - Modelos de Optimización"
    )

    # Widget para seleccionar el archivo de entrada
    input_file = st.file_uploader("Seleccionar archivo de entrada")
    if input_file is not None:
        # Mostrar los datos del archivo de entrada
        formatted_content = format_data(input_file)
        st.text_area("Parámetros de entrada", formatted_content)

        # Crear archivo .dzn y usar modelo para mostrar la solución
        if st.button("Generar solución"):
            output_filename = input_file.name.split(".")[0] + ".dzn"
            # Crear archivo .dzn con un Nombre por defecto
            # output_filename = "CalDep.dzn"
            with open(f"DatosCalDep/{output_filename}", "w") as output_file:
                output_file.write(formatted_content)
            st.info(f"Resolviendo {output_filename}")

            # Solver
            # Cargar el modelo .mzn
            cal_dep_model = Model("CalDep.mzn")
            # Asignar valores a los parámetros
            cal_dep_model.add_file(f"DatosCalDep/{output_filename}")
            # Seleccionar el solver Gecode
            gecode = Solver.lookup("gecode")
            # Crear una instancia del modelo con Gecode
            instance = Instance(gecode, cal_dep_model)
            # Resolver el modelo
            result = instance.solve()
            # Mostrar la solución
            st.write(f"Costo de viajes: {result.solution.objective}")

            st.write(f"Calendario:")
            for row in result.solution.Cal:
                st.write(f"{row}")


if __name__ == "__main__":
    main()
