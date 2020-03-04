package kr.jell.kakapmap.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/map") 
public class kakaomapController {

	@GetMapping("/test") 
	public String testWelcome() {
		return "/kakaomap/index_catagory_with_search"; 
	}
	
	@GetMapping("/") 
	public String welcome() {
		return "/kakaomap/index"; 
	}
	
}
