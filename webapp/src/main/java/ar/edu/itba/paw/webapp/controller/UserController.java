package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ImageService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.interfaces.services.WatchlistService;
import ar.edu.itba.paw.interfaces.services.exception.UserAlreadyExistsException;
import ar.edu.itba.paw.models.Image;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Review;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import ar.edu.itba.paw.webapp.form.RegisterForm;
import ar.edu.itba.paw.webapp.form.UpdatePersonalDataForm;
import ar.edu.itba.paw.webapp.form.UpdateUsernameForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.List;
import java.util.Locale;

@Controller
public class UserController {

    private final UserService userService;
    private final ImageService imageService;
    private final ReviewService reviewService;
    private final WatchlistService watchlistService;
    private final RatingService ratingService;
    private final UserDetailsService userDetailsService;

    @Autowired
    public UserController(final UserService userService,
                          final ImageService imageService,
                          final ReviewService reviewService,
                          final WatchlistService watchlistService,
                          final RatingService ratingService,
                          final UserDetailsService userDetailsService) {
        this.userService = userService;
        this.imageService = imageService;
        this.reviewService = reviewService;
        this.watchlistService = watchlistService;
        this.ratingService = ratingService;
        this.userDetailsService = userDetailsService;
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView login(@RequestParam(value = "error", required = false) final String error,
                              @RequestParam(value = "logout", required = false) final String logout,
                              @RequestParam(value = "registered", required = false) final String registered,
                              @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }

        final ModelAndView mav = new ModelAndView("users/login");
        mav.addObject("hasError", "1".equals(error));
        mav.addObject("loggedOut", "1".equals(logout));
        mav.addObject("registered", "1".equals(registered));
        return mav;
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public ModelAndView registerForm(@AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }

        return registerView(new RegisterForm());
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public ModelAndView register(@Valid @ModelAttribute("registerForm") final RegisterForm form,
                                 final BindingResult errors,
                                 final HttpServletRequest request,
                                 final HttpServletResponse response,
                                 @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }

        form.setEmail(normalizeEmail(form.getEmail()));

        if (!form.passwordsMatch()) {
            errors.rejectValue("repeatPassword", "auth.register.repeatPassword.mismatch");
        }

        if (errors.hasErrors()) {
            return registerView(errors);
        }

        try {
            userService.create(form.getEmail(), form.getPassword(), form.getUsername());
            authenticateUser(form.getEmail());
            return new ModelAndView("redirect:" + resolvePostRegisterTarget(request, response));
        } catch (final UserAlreadyExistsException e) {
            errors.rejectValue("email", "auth.register.email.taken");
            return registerView(errors);
        }
    }

    @RequestMapping(value = "/users/me", method = RequestMethod.GET)
    public ModelAndView profile(@AuthenticationPrincipal final PawAuthUser authUser) {
        final ModelAndView mav = buildProfileMav(authUser);
        mav.addObject("updatePersonalDataForm", new UpdatePersonalDataForm());
        return mav;
    }

    @RequestMapping(value = "/users/me/username", method = RequestMethod.POST)
    public ModelAndView updateUsername(@AuthenticationPrincipal final PawAuthUser authUser,
                                       @Valid @ModelAttribute("updateUsernameForm") final UpdateUsernameForm form,
                                       final BindingResult errors) {
        if (errors.hasErrors()) {
            final ModelAndView mav = buildProfileMav(authUser);
            mav.addObject("updatePersonalDataForm", new UpdatePersonalDataForm());
            return mav;
        }
        userService.updateUsername(authUser.getUser().getId(), form.getUsername());
        authenticateUser(authUser.getUser().getEmail());
        return new ModelAndView("redirect:/users/me");
    }

    @RequestMapping(value = "/users/me/picture", method = RequestMethod.POST)
    public ModelAndView updatePicture(@AuthenticationPrincipal final PawAuthUser authUser,
                                      @RequestParam("picture") final MultipartFile file) {
        if (file == null || file.isEmpty() || file.getContentType() == null
                || !file.getContentType().startsWith("image/")) {
            return new ModelAndView("redirect:/users/me");
        }
        try {
            final Image img = imageService.create(file.getContentType(), file.getBytes());
            userService.updateImage(authUser.getUser().getId(), img.getId());
            authenticateUser(authUser.getUser().getEmail());
        } catch (final Exception ignored) {
            // Non-fatal: redirect to profile without updating
        }
        return new ModelAndView("redirect:/users/me");
    }

    @RequestMapping(value = "/users/me/personal", method = RequestMethod.POST)
    public ModelAndView updatePersonalData(@AuthenticationPrincipal final PawAuthUser authUser,
                                           @Valid @ModelAttribute("updatePersonalDataForm") final UpdatePersonalDataForm form,
                                           final BindingResult errors) {
        if (errors.hasErrors()) {
            final ModelAndView mav = buildProfileMav(authUser);
            mav.addObject("updatePersonalDataForm", form);
            mav.addObject("activeTab", "account");
            return mav;
        }
        if (form.getUsername() != null && !form.getUsername().trim().isEmpty()) {
            userService.updateUsername(authUser.getUser().getId(), form.getUsername());
        }
        if (form.getBio() != null) {
            userService.updateBio(authUser.getUser().getId(), form.getBio());
        }
        authenticateUser(authUser.getUser().getEmail());
        return new ModelAndView("redirect:/users/me");
    }

    private ModelAndView buildProfileMav(final PawAuthUser authUser) {
        final long userId = authUser.getUser().getId();
        final ModelAndView mav = new ModelAndView("users/profile");
        mav.addObject("currentUserEmail", authUser.getUser().getEmail());
        mav.addObject("currentUsername", authUser.getUser().getUsername());
        mav.addObject("currentUserImageId", authUser.getUser().getImageId());
        mav.addObject("currentUserBio", authUser.getUser().getBio());
        mav.addObject("reviews", reviewService.findByUser(userId));
        mav.addObject("updateUsernameForm", new UpdateUsernameForm());
        final List<Production> watchlist = watchlistService.findByUser(userId);
        mav.addObject("watchlist", watchlist);
        mav.addObject("productionRatings", ratingService.getProductionRatingLabels(collectProductionIds(watchlist)));
        return mav;
    }

    private List<Long> collectProductionIds(final List<Production> productions) {
        final List<Long> ids = new java.util.ArrayList<>();
        for (final Production p : productions) {
            ids.add(p.getId());
        }
        return ids;
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

    private void authenticateUser(final String email) {
        final UserDetails userDetails = userDetailsService.loadUserByUsername(email);
        final UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                userDetails,
                userDetails.getPassword(),
                userDetails.getAuthorities()
        );
        SecurityContextHolder.getContext().setAuthentication(authentication);
    }

    private String resolvePostRegisterTarget(final HttpServletRequest request,
                                             final HttpServletResponse response) {
        final HttpSessionRequestCache requestCache = new HttpSessionRequestCache();
        final SavedRequest savedRequest = requestCache.getRequest(request, response);

        requestCache.removeRequest(request, response);
        if (savedRequest != null) {
            return savedRequest.getRedirectUrl();
        }

        final String contextPath = request.getContextPath();
        return (contextPath != null ? contextPath : "") + "/users/me";
    }
}
