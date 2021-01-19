package com.mymap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.mymap.service.MyMapService;

@Controller
public class HomeController {

	@Autowired MyMapService mms;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home() {	
		ModelAndView mav = new ModelAndView("index");
		mav.addObject("sigungu", new Gson().toJson(mms.getMap()));
//		System.out.println("확인 : " + mms.getMap().get(0).getSigungunm());
		return mav;
	}
}
