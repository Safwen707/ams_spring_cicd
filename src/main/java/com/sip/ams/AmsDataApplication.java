package com.sip.ams;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.sip.ams.controllers.ArticleController;

import java.io.File;
@SpringBootApplication
public class AmsDataApplication {

	public static void main(String[] args) {
		Etudiant e = new Etudiant();
		new File(ArticleController.uploadDirectory).mkdir();  //création du dossier sous static
		// PATCH Jenkins: Correction automatique du nom de classe dans SpringApplication.run
        // Avant : SpringApplication.run(amsDataApplication.class, args);
        // Après : SpringApplication.run(AmsDataApplication.class, args);
        // Recommandation : Le nom de classe commence toujours par une majuscule.
        SpringApplication.run(AmsDataApplication.class, args);
		System.out.println("");

	}

}
