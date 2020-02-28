package kr.jell.chart.web;

import java.util.Locale;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.jell.chart.service.ChartService;

@Controller
@RequestMapping("/chart") 
public class ChartController {
	@Resource(name = "chartService")
	ChartService chartService;
	
	@RequestMapping("/") 
	public String welcome() {
		return "/chart/index"; 
	}
	
	@GetMapping(value = "/chartjs")
  	public String home(Locale locale, Model model)throws Exception {


  		int womenCount = chartService.getWomenCount();
  		int menCount = chartService.getMenCount();

  		model.addAttribute("menCount", menCount);
  		model.addAttribute("womenCount", womenCount);

  		return "/chart/index";

  	}
}
