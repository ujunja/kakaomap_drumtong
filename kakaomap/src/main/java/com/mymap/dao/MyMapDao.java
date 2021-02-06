package com.mymap.dao;

import java.util.List;

import com.mymap.vo.emdvo;
import com.mymap.vo.shopvo;
import com.mymap.vo.sidovo;
import com.mymap.vo.sigunguvo;

public interface MyMapDao {

	List<sidovo> getSidoXY();

	List<sigunguvo> getSigunguXY();

	List<emdvo> getEmdXY();

}
