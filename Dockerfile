# ETAPA 1: Construcción (Aquí compilamos)
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
# Copiamos todo el código fuente al contenedor
COPY . .
# Compilamos el proyecto usando Maven Wrapper
RUN ./mvnw clean package -DskipTests

# ETAPA 2: Ejecución (Aquí solo corremos la app)
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
# Copiamos solo el JAR final que se creó en la etapa anterior
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]