package com.example.demo;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloController {

	@RequestMapping("/")
	public String index() {
		return "Greetings from Spring Boot!!!!!?=*&%";
	}

	@RequestMapping("/mo")
	public String mo() {
		return "Matej Ocovsky";
	}

	@RequestMapping("/ls")
	public String ls() {
		return "Lewis Smith";
	}

}