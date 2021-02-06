package com.mymap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.mymap.awsdao.AwsDao;
import com.mymap.dao.MyMapDao;
import com.mymap.vo.emdvo;
import com.mymap.vo.shopvo;
import com.mymap.vo.sidovo;
import com.mymap.vo.sigunguvo;

@Service
public class MyMapService {

	@Autowired MyMapDao mmd;
	@Autowired AwsDao awd;
	
	public String getSidoXY() {
		List<sidovo> sido = mmd.getSidoXY();
		return new Gson().toJson(sido);
	}

	public String getSigunguXY() {
		List<sigunguvo> sigungu = mmd.getSigunguXY();
		return new Gson().toJson(sigungu);
	}

	public String getEmdXY() {
		List<emdvo> emd = mmd.getEmdXY();
		return new Gson().toJson(emd);
	}

	public String getShopXY() {
		List<shopvo> shop = awd.getShopXY();
		return new Gson().toJson(shop);
	}
}
