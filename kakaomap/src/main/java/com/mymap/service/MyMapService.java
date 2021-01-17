package com.mymap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mymap.dao.MyMapDao;

@Service
public class MyMapService {

	@Autowired MyMapDao mmd;
	
	public List<String> getMap() {
		return mmd.getMap();
	}

}
