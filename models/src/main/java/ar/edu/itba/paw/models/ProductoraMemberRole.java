package ar.edu.itba.paw.models;

public enum ProductoraMemberRole {
    OWNER,
    MEMBER;

    public static ProductoraMemberRole fromString(final String raw) {
        if (raw == null) return MEMBER;
        try {
            return ProductoraMemberRole.valueOf(raw);
        } catch (IllegalArgumentException e) {
            return MEMBER;
        }
    }
}
