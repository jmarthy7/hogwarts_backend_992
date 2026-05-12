# ====== Etapa 1: Fase de construcción ======
FROM maven:3.9-eclipse-temurin-21 AS imagen_construccion

# Definimos un directorio de trabajo limpio
WORKDIR /app

# Copiamos los archivos necesarios para compilar
COPY pom.xml .
COPY src ./src

# Construimos el paquete saltando los tests para acelerar el proceso
RUN mvn clean package -DskipTests

# ====== Etapa 2: Fase de ejecución ======
FROM eclipse-temurin:21-jre AS imagen_ejecucion

WORKDIR /app

# Copiamos el .jar desde la etapa de construcción
# Usamos el wildcard *.jar para que no importe el nombre exacto definido en el pom
COPY --from=imagen_construccion /app/target/*.jar app.jar

# Exponemos el puerto de la aplicación
EXPOSE 8080

# Comando de arranque
ENTRYPOINT ["java", "-jar", "app.jar"]
