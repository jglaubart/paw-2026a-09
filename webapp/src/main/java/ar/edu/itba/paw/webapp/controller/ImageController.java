package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ImageService;
import ar.edu.itba.paw.models.Image;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.Duration;
import java.util.Optional;

@Controller
public class ImageController {

    private final ImageService imageService;

    @Autowired
    public ImageController(final ImageService imageService) {
        this.imageService = imageService;
    }

    @ResponseBody
    @RequestMapping(value = "/images/{id:\\d+}", method = RequestMethod.GET)
    public ResponseEntity<byte[]> image(@PathVariable("id") final long id) {
        return resolveImageResponse(id);
    }

    @ResponseBody
    @RequestMapping(value = "/petition-images/{id:\\d+}", method = RequestMethod.GET)
    public ResponseEntity<byte[]> petitionImage(@PathVariable("id") final long id) {
        return resolveImageResponse(id);
    }

    private ResponseEntity<byte[]> resolveImageResponse(final long id) {
        final Optional<Image> image = imageService.findById(id);
        if (!image.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        final Image resolvedImage = image.get();
        final HttpHeaders headers = new HttpHeaders();
        headers.setContentType(parseContentType(resolvedImage.getContentType()));
        headers.setCacheControl(CacheControl.maxAge(Duration.ofHours(12)).cachePublic());
        return new ResponseEntity<>(resolvedImage.getContent(), headers, HttpStatus.OK);
    }

    private MediaType parseContentType(final String contentType) {
        try {
            return MediaType.parseMediaType(contentType);
        } catch (final IllegalArgumentException e) {
            return MediaType.APPLICATION_OCTET_STREAM;
        }
    }
}
