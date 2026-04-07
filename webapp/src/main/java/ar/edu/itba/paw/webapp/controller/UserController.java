package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.models.Review;
import ar.edu.itba.paw.models.User;
import ar.edu.itba.paw.webapp.auth.PawUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
public class UserController {

    private final UserService userService;
    private final ReviewService reviewService;
    private final UserDetailsService userDetailsService;

    @Autowired
    public UserController(final UserService userService,
                          final ReviewService reviewService,
                          final UserDetailsService userDetailsService) {
        this.userService = userService;
        this.reviewService = reviewService;
        this.userDetailsService = userDetailsService;
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView loginForm(@AuthenticationPrincipal final PawUserDetails userDetails) {
        if (userDetails != null) {
            return new ModelAndView("redirect:/users/me");
        }
        return new ModelAndView("users/login");
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public ModelAndView registerForm(@AuthenticationPrincipal final PawUserDetails userDetails) {
        if (userDetails != null) {
            return new ModelAndView("redirect:/users/me");
        }
        return new ModelAndView("users/register");
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public ModelAndView register(
            @RequestParam("email") final String email,
            @RequestParam("password") final String password,
            final HttpServletRequest request,
            final HttpServletResponse response) {

        if (userService.findByEmail(email).isPresent()) {
            final ModelAndView mav = new ModelAndView("users/register");
            mav.addObject("emailTaken", true);
            return mav;
        }

        final User user = userService.create(email, password);

        final UserDetails authUser = userDetailsService.loadUserByUsername(user.getEmail());
        final Authentication auth = new UsernamePasswordAuthenticationToken(
                authUser, authUser.getPassword(), authUser.getAuthorities()
        );
        SecurityContextHolder.getContext().setAuthentication(auth);

        final HttpSessionRequestCache requestCache = new HttpSessionRequestCache();
        final SavedRequest savedRequest = requestCache.getRequest(request, response);
        requestCache.removeRequest(request, response);

        final String targetUrl = (savedRequest != null)
                ? savedRequest.getRedirectUrl()
                : request.getContextPath() + "/";
        return new ModelAndView("redirect:" + targetUrl);
    }

    @RequestMapping(value = "/users/me", method = RequestMethod.GET)
    public ModelAndView profile(@AuthenticationPrincipal final PawUserDetails userDetails) {
        final ModelAndView mav = new ModelAndView("users/profile");
        final List<Review> reviews = reviewService.findByUser(userDetails.getUser().getId());
        mav.addObject("reviews", reviews);
        return mav;
    }
}
