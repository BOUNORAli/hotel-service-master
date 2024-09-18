package fr.scpit.backend.data;

import fr.scpit.backend.category.Category;
import fr.scpit.backend.category.CategoryRepository;
import fr.scpit.backend.food.Food;
import fr.scpit.backend.food.FoodRepository;
import fr.scpit.backend.order.Order;
import fr.scpit.backend.order.OrderRepository;
import fr.scpit.backend.order_item.OrderItem;
import fr.scpit.backend.order_item.OrderItemRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;

@Component
@Slf4j
public class DataPopulator implements CommandLineRunner {

    private final CategoryRepository categoryRepository;
    private final FoodRepository foodRepository;
    private final OrderItemRepository orderItemRepository;
    private final OrderRepository orderRepository;

    @Autowired
    public DataPopulator(CategoryRepository categoryRepository, FoodRepository foodRepository, OrderItemRepository orderItemRepository, OrderRepository orderRepository) {
        this.categoryRepository = categoryRepository;
        this.foodRepository = foodRepository;
        this.orderItemRepository = orderItemRepository;
        this.orderRepository = orderRepository;
    }

    @Override
    public void run(String... args) {
        // Sample category data
        Category category1 = Category.builder()
                .categoryName("Chicken")
                .categoryImage("assets/category/chicken.png")
                .build();

        Category category2 = Category.builder()
                .categoryName("Bakery")
                .categoryImage("assets/category/bakery.png")
                .build();

        Category category3 = Category.builder()
                .categoryName("Fast Food")
                .categoryImage("assets/category/fastfood.png")
                .build();

        Category category4 = Category.builder()
                .categoryName("Fish")
                .categoryImage("assets/category/fish.png")
                .build();

        Category category5 = Category.builder()
                .categoryName("Fruit")
                .categoryImage("assets/category/fruit.png")
                .build();

        Category category6 = Category.builder()
                .categoryName("Soup")
                .categoryImage("assets/category/soup.png")
                .build();

        Category category7 = Category.builder()
                .categoryName("Vegetable")
                .categoryImage("assets/category/vegetable.png")
                .build();

        categoryRepository.saveAll(Arrays.asList(category1, category2, category3, category4, category5, category6, category7));

        // Sample food data
        Food food1 = Food.builder()
                .name("Chicken Curry Pasta")
                .price("10.99")
                .categories(Collections.singletonList(category1))
                .favorite(false)
                .recommend(true)
                .popular(true)
                .stars(4)
                .imageUrl("assets/food/ChickenCurryPasta.jpg")
                .cuisines(Collections.singletonList("Italian"))
                .cookTime("30 minutes")
                .build();

        Food food2 = Food.builder()
                .name("Mandarin Pancake")
                .price("8.99")
                .categories(Collections.singletonList(category2))
                .favorite(false)
                .recommend(true)
                .popular(true)
                .stars(3)
                .imageUrl("assets/food/MandarinPancake.jpg")
                .cuisines(Collections.singletonList("Frensh"))
                .cookTime("35 minutes")
                .build();

        Food food3 = Food.builder()
                .name("Explosion Burger")
                .price("9.99")
                .categories(Collections.singletonList(category3))
                .favorite(false)
                .recommend(true)
                .popular(true)
                .stars(3)
                .imageUrl("assets/food/ExplosionBurger.jpg")
                .cuisines(Collections.singletonList("Algerian"))
                .cookTime("15 minutes")
                .build();

        Food food4 = Food.builder()
                .name("Grilled Chicken")
                .price("18.95")
                .categories(Collections.singletonList(category2))
                .favorite(true)
                .recommend(true)
                .popular(true)
                .stars(3)
                .imageUrl("assets/food/GrilledChicken.jpg")
                .cuisines(Collections.singletonList("Turkish"))
                .cookTime("30 minutes")
                .build();

        Food food5 = Food.builder()
                .name("Heavenly Pizza")
                .price("11.92")
                .categories(Collections.singletonList(category3))
                .favorite(false)
                .recommend(true)
                .popular(true)
                .stars(3)
                .imageUrl("assets/food/HeavenlyPizza.jpg")
                .cuisines(Collections.singletonList("Italian"))
                .cookTime("40 minutes")
                .build();

        Food food6 = Food.builder()
                .name("Grilled Fish")
                .price("8.99")
                .categories(Collections.singletonList(category4))
                .favorite(false)
                .recommend(true)
                .popular(true)
                .stars(3)
                .imageUrl("assets/food/GrilledFish.jpg")
                .cuisines(Collections.singletonList("Spanish"))
                .cookTime("25 minutes")
                .build();

        Food food7 = Food.builder()
                .name("Organic Mandarin")
                .price("20.05")
                .categories(Collections.singletonList(category2))
                .favorite(false)
                .recommend(true)
                .popular(true)
                .stars(3)
                .imageUrl("assets/food/OrganicMandarin.jpg")
                .cuisines(Collections.singletonList("Moroccan"))
                .cookTime("10 minutes")
                .build();

        Food food8 = Food.builder()
                .name("Organic Orange")
                .price("12")
                .categories(Collections.singletonList(category4))
                .favorite(false)
                .recommend(true)
                .popular(true)
                .stars(3)
                .imageUrl("assets/food/OrganicOrange.jpg")
                .cuisines(Collections.singletonList("Mexican"))
                .cookTime("45 minutes")
                .build();

        Food food9 = Food.builder()
                .name("Raspberries Cake")
                .price("28.00")
                .categories(Collections.singletonList(category2))
                .favorite(false)
                .recommend(true)
                .popular(true)
                .stars(3)
                .imageUrl("assets/food/RaspberriesCake.jpg")
                .cuisines(Collections.singletonList("Mexican"))
                .cookTime("45 minutes")
                .build();

        foodRepository.saveAll(Arrays.asList(food1, food2, food3, food4, food5, food6, food7, food8, food9));

        // Sample order item data
        OrderItem orderItem1 = OrderItem.builder()
                .food(food1)
                .price(10.99)
                .quantity(2)
                .build();

        OrderItem orderItem2 = OrderItem.builder()
                .food(food2)
                .price(8.99)
                .quantity(1)
                .build();

        orderItemRepository.saveAll(Arrays.asList(orderItem1, orderItem2));

        // Sample order data
        Order order = Order.builder()
                .name("John Doe")
                .address("123 Main St")
                .paymentId("PAYMENT_ID")
                .totalPrice(29.97)
                .items(Arrays.asList(orderItem1, orderItem2))
                .status("Pending")
                .user("USER_ID")
                .createdAt(LocalDateTime.parse("2022-04-01T12:00:00"))
                .updatedAt(LocalDateTime.parse("2022-04-01T12:00:00"))
                .build();

        orderRepository.save(order);

        log.info("Sample data inserted into MongoDB.");
    }
}
