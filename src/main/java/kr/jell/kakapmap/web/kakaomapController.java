package kr.jell.kakapmap.web;

import java.util.Locale;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.jell.chart.service.ChartService;

@Controller
@RequestMapping("/map") 
public class kakaomapController {

	@RequestMapping("/") 
	public String welcome() {
		return "/kakaomap/index"; 
	}
	
}
