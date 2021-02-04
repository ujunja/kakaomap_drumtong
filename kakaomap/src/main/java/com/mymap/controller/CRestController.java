package com.mymap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import com.google.gson.Gson;
import com.mymap.service.MyMapService;

@RestController
@RequestMapping("mymap/")
public class CRestController {
	@Autowired MyMapService mms;
	
	// produces 를 넣지 않으면 브라우저 상에서 문자열이 물음표로 출력됩니다
	@RequestMapping(value = "sidomap/rest/", produces =org.springframework.http.MediaType.APPLICATION_JSON_UTF8_VALUE)
	@PostMapping(produces="application/json; charset=utf8")
	public String getsido() {
		return mms.getSidoXY();
	}

	// produces 를 넣지 않으면 브라우저 상에서 문자열이 물음표로 출력됩니다
	@RequestMapping(value = "sigungumap/rest/", produces =org.springframework.http.MediaType.APPLICATION_JSON_UTF8_VALUE)
	@PostMapping(produces="application/json; charset=utf8")
	public String getsigungu() {
		return mms.getSigunguXY();
	}

	// produces 를 넣지 않으면 브라우저 상에서 문자열이 물음표로 출력됩니다
	@RequestMapping(value = "emdmap/rest/", produces =org.springframework.http.MediaType.APPLICATION_JSON_UTF8_VALUE)
	@PostMapping(produces="application/json; charset=utf8")
	public String getemd() {
		return mms.getEmdXY();
	}
}
