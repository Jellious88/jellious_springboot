package kr.jell.chart.service.impl;

import org.springframework.stereotype.Service;

import kr.jell.chart.service.ChartService;

@Service("chartService")
public class ChartServiceImpl implements ChartService{
//	@Resource(name="rsrcPoolDao") RsrcPoolDao rsrcPoolDao;

	@Override
	public int getWomenCount() {
		// TODO Auto-generated method stub
		// RsrcPoolVo rsrcPoolVo = rsrcPoolDao.selectRsrcPool(loadBalancerListenerVo.getRsrcPoolId());
		return 10;
	}

	@Override
	public int getMenCount() {
		// TODO Auto-generated method stub
		return 5;
	}

}
