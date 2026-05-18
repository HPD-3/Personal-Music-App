allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    afterEvaluate {
        if (hasProperty("android")) {
            configure<com.android.build.gradle.BaseExtension> {
                // Set namespace for on_audio_query_android specifically
                if (project.name == "on_audio_query_android") {
                    namespace = "com.lucasjosino.on_audio_query"
                } else if (namespace == null) {
                    namespace = "com.example.personal_music_app"
                }
                
                // Set consistent JVM compatibility for all subprojects
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
