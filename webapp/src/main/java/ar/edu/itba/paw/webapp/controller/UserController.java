package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.interfaces.services.exception.UserAlreadyExistsException;
import ar.edu.itba.paw.models.Review;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import ar.edu.itba.paw.webapp.form.RegisterForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.util.List;
import java.util.Locale;

@Controller
public class UserController {

    private final UserService userService;
    private final ReviewService reviewService;

    @Autowired
    public UserController(final UserService userService,
                          final ReviewService reviewService
                          /*, final RatingService ratingService */) {
        this.userService = userService;
        this.reviewService = reviewService;
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView login(@RequestParam(value = "error", required = false) final String error,
                              @RequestParam(value = "logout", required = false) final String logout,
                              @RequestParam(value = "registered", required = false) final String registered) {
        final ModelAndView mav = new ModelAndView("users/login");
        mav.addObject("hasError", "1".equals(error));
        mav.addObject("loggedOut", "1".equals(logout));
        mav.addObject("registered", "1".equals(registered));
        return mav;
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public ModelAndView registerForm() {
        return registerView(new RegisterForm());
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public ModelAndView register(@Valid @ModelAttribute("registerForm") final RegisterForm form,
                                 final BindingResult errors) {
        form.setEmail(normalizeEmail(form.getEmail()));

        if (!form.passwordsMatch()) {
            errors.rejectValue("repeatPassword", "auth.register.repeatPassword.mismatch");
        }

        if (errors.hasErrors()) {
            return registerView(errors);
        }

        try {
            userService.create(form.getEmail(), form.getPassword());
            return new ModelAndView("redirect:/login?registered=1");
        } catch (final UserAlreadyExistsException e) {
            errors.rejectValue("email", "auth.register.email.taken");
            return registerView(errors);
        }
    }

    @RequestMapping(value = "/users/me", method = RequestMethod.GET)
    public ModelAndView profile(@AuthenticationPrincipal final PawAuthUser authUser) {
        final ModelAndView mav = new ModelAndView("users/profile");
        final List<Review> reviews = reviewService.findByUser(authUser.getUser().getId());
        mav.addObject("currentUserEmail", authUser.getUser().getEmail());
        mav.addObject("reviews", reviews);
        return mav;
    }

    private ModelAndView registerView(final RegisterForm form) {
        final ModelAndView mav = new ModelAndView("users/register");
        mav.addObject("registerForm", form);
        return mav;
    }

    private ModelAndView registerView(final BindingResult errors) {
        return new ModelAndView("users/register", errors.getModel());
    }

    private String normalizeEmail(final String email) {
        if (email == null) {
            return null;
        }
        return email.trim().toLowerCase(Locale.ROOT);
    }
}
